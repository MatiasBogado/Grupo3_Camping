const db = require('../database/models');
const { validationResult } = require('express-validator');
const {Op} = require('sequelize');

const products = {

    agregar: function (req, res, next) {
        let errores = validationResult(req);
        if (errores.isEmpty()) {
            db.Products.create({
                nombre: req.body.title.trim(),
                precio: Number(req.body.price),
                descuento: Number(req.body.discount),
                descripcion: req.body.description.trim(),
                imagenes: (req.files[0]) ? req.files[0].filename : "default.jpg",
                id_category: req.body.categoria,
                stock: req.body.stock,
                destacado: req.body.destacado

            })
                .then(result => {
                    console.log(result)
                    res.redirect('/products/admin/1#listadoProductos')
                })

                .catch(errores => {
                    console.log(errores)
                })
        }else{
            res.redirect("/products/admin/1#agregarProducto")
        }
    },

    listar: function (req, res) {
        db.Products.findAll()
            .then(function (productos) {
                return res.render('products', {
                    title: "Todos los Productos",
                    productos: productos,
                    user: req.session.user
                }) //muestra información de prueba
            })
            .catch(errores => {
                console.log(errores)
            })

    },

    addView: function (req, res) {
        db.Categories.findAll()
            .then(function (categorias) {
                return res.render('productAdd', {
                    categorias: categorias,
                    user: req.session.user
                })
            })
            .catch(errores => {
                console.log(errores)
            })


    },
    productDetail: function (req, res) {
        db.Products.findOne({
            where: {
                id: req.params.id
            }
        })
            .then(function (producto) {
                return res.render('productDetail', {
                    title: "Detalle del Producto",
                    producto: producto,
                    user: req.session.user
                })
            })
            .catch(errores => {
                console.log(errores)
            })
    },
    buscar: function (req, res) {
        if (req.query.search == "") {
            res.redirect('/')
        }
        let search = req.query.search;
        db.Products.findAll({
                where: {
                    nombre: {
                        [Op.like]: `%${search}%`
                    }
                }
            })
            .then(result => {
                if(result.length>0){
                    res.render('products', {
                        title: `Resultado de la búsqueda "${search}"`,
                        productos: result,
                    })
                }else{
                    res.render('products', {
                        title: `No hay resultados en su busqueda "${search}"` ,
                        productos: result,
                    })
                }
            })
            .catch(errors => {
                res.send(errors)
            })
    },

    enCarrito: function (req, res) {
        let prodCarrito = db.Carts.findAll({include:[{association:"productos"},{association:"Users"}]})

        let Productos = db.Products.findAll({
            include:[{association:"categoria"}]
        })

        Promise.all([prodCarrito,Productos])
        .then(function ([prodCarrito,Productos]) {
            /* en el carrito se guardan todos los productos de todos los usuarios */
            /* hay que separarlos para mostrarlos en la vista */

            
           let totalProduct = []/* total de productos en el  carrito de un usuario en especifico */
           let precios=[]/* cada uno de los precios de los productos del carrito de un usuario */
           let cantidad;
           
           prodCarrito.forEach(product=>{     
                if (product.id_user == req.session.user.id){ /* separo los productos de cada usuario*/
                    totalProduct.push(product)
                    precios.push(product.productos.precio)
                    cantidad = product.cantidad
                    
                }
            })
            let precioTotal;
            if(precios.length>=1){
                precioTotal = precios.reduce(function(a, b){ return a + b; });/* suma de precios de los productos de UN usuario */
            }
        
        
            res.render('productCart', {
                title: 'Carrito de Compras',
                productoEnCarrito: prodCarrito,
                user: req.session.user,
                totalProductoEnCarrito : totalProduct.length,
                precioTotal:precioTotal,
                cantidad:cantidad,
                productos:Productos

            })            
                
        })
        
        .catch(errores => {
            console.log(errores)
        })
    },
    agregarAlCarrito: function (req, res) {

        db.Carts.create({
            cantidad:req.body.quantity,
            products_id:req.params.id,
            id_user:req.session.user.id
        })
        .then(result => {
            console.log(result)
            res.redirect('/products/cart')
        })
        .catch(errors=>{
            console.log(errors)
        })
    },
    retiraDelCarrito: function (req, res) {
        db.Carts.destroy({
            where: {
                id: req.params.id
            }
        })
        res.redirect('/products/cart')
    },
    deleteAllCarrito: function (req,res) {
         
        db.Carts.destroy({
            where: {
                id_user : req.session.user.id
            }
        })
        res.redirect('/products/cart')
    },
    confirm:function (req,res){
        db.Carts.findAll({include:[{association:"productos"},{association:"Users"}]})
        .then(function (productos) {
            /* en el carrito se guardan todos los productos de todos los usuarios */
            /* hay que separarlos para mostrarlos en la vista */
           let totalProduct = []/* total de productos en el  carrito de un usuario en especifico */
           let precios=[]/* cada uno de los precios de los productos del carrito de un usuario */
           let cantidad;
           let productID;
           let precioTotal;
           if(precios.length>=1){
               precioTotal = precios.reduce(function(a, b){ return a + b; });/* suma de precios de los productos de UN usuario */
           }
            productos.forEach(product=>{     


                if (product.id_user == req.session.user.id){ /* separo los productos de cada usuario*/
                    totalProduct.push(product)
                    precios.push(product.productos.precio)
                    cantidad = product.cantidad
                    productID= product.productos.id   
                    db.Ventas.create({
                        id_users: req.session.user.id,
                        id_products: productID,
                        cantidad:cantidad
                    })
                    db.Carts.destroy({
                        where: {
                            id_user : req.session.user.id
                        }
                    })
                    
                    res.render('compraConfirm', {
                        title: 'Compra Confirmada',
                    })     
                }
            })
        })
        .catch(errores => {
            console.log(errores)
        })
    },
    show: function (req, res) {

        let id = db.Products.findByPk(req.params.id)
        let todos = db.Products.findAll()
        Promise.all([id, todos])
            .then(function ([idProd, todosProd]) {
                res.render('productShow', {
                    title: "Ver/Editar Producto",
                    producto: idProd,
                    total: todosProd.length,
                    productDb: todosProd,
                    user: req.session.user
                })
            })
            .catch(errores => {
                console.log(errores)
            })

    },
    editar: function (req, res) {
        let errores = validationResult(req);
        if (errores.isEmpty()) {
        db.Products.update({
            nombre: req.body.nameEdit.trim(),
            precio: Number(req.body.priceEdit),
            descuento: Number(req.body.discountEdit),
            descripcion: req.body.descriptionEdit.trim(),
            imagenes: (req.files[0])?req.files[0].filename:req.files[0],
            id_category: Number(req.body.categoriaEdit),
            stock: req.body.stockEdit,
            destacado: req.body.destacadoEdit
        }, {
            where: {
                id: req.params.id
            }
        })  
        .then(result => {
            console.log(result)
            res.redirect('/products/admin/'+req.params.id+"#detalleProducto")
        })
        .catch(errores => {
            console.log(errores)
        })
        }else{
        res.redirect('/products/admin/' + req.params.id + "#editarProducto")
        }
    },
    eliminarProd: function (req, res) {
        db.Products.destroy({
            where: {
                id: req.params.id
            }
        })
        res.redirect('/products/admin/1')
    },
    admin: function (req, res) {
        let usuarios = db.Users.findAll()
        let show = req.params.show
        let id = db.Products.findByPk(req.params.id, {
            include: [{ association: "categoria" }]
        })
        let todos = db.Products.findAll({
            include: [{ association: "categoria" }]
        })
        let categorias = db.Categories.findAll()
        let idCategory = db.Categories.findByPk(req.params.id)
        let ventas = db.Ventas.findAll()

        Promise.all([id, todos, categorias,idCategory, ventas,usuarios])
            .then(function ([idProd, todosProd, categoriasProd,idCategoryProd, ventaProd,usuariosProd]) {
                res.render('adminProducts', {
                    title: "Administración de Productos",
                    producto: idProd,
                    total: todosProd.length,
                    show: show,
                    productosTotales: todosProd,
                    categorias: categoriasProd,
                    idCategory:idCategoryProd,
                    ventas: ventaProd,
                    usuarios:usuariosProd
                })
            })
            .catch(errores => {
                console.log(errores)
            })
    },
    categories: function(req,res,next){
        db.Products.findAll({
           include: [{ association: "categoria" }],
           where:{
               id_category:req.params.categories
           }
       })
       .then(products =>{

        let titulo = []
        products.forEach(product =>{
            titulo.push(product.categoria.nombre)
        })
        
           res.render("products",{
               title:"categoria: " + titulo[0],
               productos:products
           })
       })
   },
    categoriesAdd: function (req, res, next){
            db.Categories.create({
                nombre: req.body.nombre,
                imagen: (req.files[0]) ? req.files[0].filename : "default.jpg",

            })
                .then(result => {
                    console.log(result)
                    res.redirect('/products/admin/1#categorias')
                })
                .catch(errores => {
                    console.log(errores)
                }) 
    },
    CategoriesEditar: function (req, res, next) {

        db.Categories.update({
            nombre: req.body.nombreEdit,
            /* imagen: (req.files[0]) ? req.files[0].filename : "default.jpg" */
        }, {
            where: {
                id: req.params.id
            }
        })
            .then(result => {
                console.log(result)
                res.redirect("/products/admin/1#categorias");
            })
            .catch(errores => {
                console.log(errores)
            })

    },
    categoriesEliminar: function (req, res) {
        db.Products.update({
            id_category: null,  
        }, {
            where: {
                id_category: req.params.id
            }
        })  
        db.Categories.destroy({
            where: {
                id: req.params.id
            }
        })
    
    .catch(error => {
        console.log(error)
    })
        res.redirect('/products/admin/1#categorias')
    }

}

module.exports = products;