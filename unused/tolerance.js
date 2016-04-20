
'/'

# HECHA # HOME
'/' -> 

# BUSCADOR DE LA HOME
'/search' -> post

# PÁGINA CON LOS FORMULARIOS DE CREACIÓN
'/create' -> get



'/account/'

# HECHA # LOGUEO DE USUARIOS  
'/login' -> POST

# HECHA # DESLOGUEO DE USUARIOS
'/login' -> get

# HECHA # REGISTRO DE USUARIOS
'/register' -> POST

# HECHA # COMPROBAR DISPONIBILIDAD DE USERNAME
'/checkname' -> POST

# RECUPERAR CONTRASEÑA
'/recover' -> post



'/user/'

# PÁGINA CON TODOS LOS ITEMS DEL USUARIO
'/:username/all' 		-> get

# PÁGINA CON TODOS LOS PRODUCTOS DEL USUARIO
'/:username/products' 	-> get

# PÁGINA CON TODOS LAS AFECCIONES DE INTERÉS PARA DEL USUARIO
'/:username/affections' -> get

# PÁGINA CON TODOS LOS LUGARES DEL USUARIO
'/:username/places' 	-> get

# PÁGINA CON TODOS LOS FAVORITOS DEL USUARIO
'/:username/favorites' 	-> get

# PÁGINA PARA GUARDAR FAVORITOS DEL USUARIO
'/:username/favorites' 	-> post

# PÁGINA CON FORMULARIO DE PERFIL DEL USUARIO
'/:username/profile' 	-> get

# PÁGINA PARA EDITAR EL PERFIL DEL USUARIO
'/:username/profile' 	-> POST



'/product/'

# DEVUELVE JSON DE TODOS LOS PRODUCTOS
'/product' 			-> get

# PÁGINA PARA CREAR PRODUCTO
'/product' 			-> post

# PÁGINA DE PRODUCTO
'/product/:slug' 	-> get

# PÁGINA PARA EDITAR PRODUCTO
'/product/edit/:slug' 	-> get

# PÁGINA PARA GUARDAR PRODUCTO
'/product/edit/:slug' 	-> post




'/affection/'

# PÁGINA DE AFECCIÓN
'/affection/:slug' 	-> get

# PÁGINA PARA GUARDAR AFECCIÓN
'/affection' 		-> post

# PÁGINA PARA EDITAR AFECCIÓN
'/affection' 		-> put



'/place/'

# PÁGINA DE LUGAR
'/place/:slug' 	-> get

# PÁGINA PARA GUARDAR LUGAR
'/place' 		-> post

# PÁGINA PARA EDITAR LUGAR
'/place' 		-> put