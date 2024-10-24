--Comience usando master y eliminando la base de datos

use master
go

drop database g05com2900
go

--Apartir de aqui comienza el script para poder crear la base de datos y todas sus tablas

create database g05com2900
go

use g05com2900
go

create schema ddbba
go

create table ddbba.TipoDeCliente (
    id int identity(1,1) primary key,
    tipo char(15) not null unique
);
go

create table ddbba.Ciudad (
    id int identity(1,1) primary key,
    nombre char(20) not null unique
);
go

create table ddbba.Genero (
    id int identity(1,1) primary key,
    tipo char(10) not null unique
);
go

create table ddbba.Cliente (
    id int identity(1,1) primary key,
    id_tipo_de_cliente int not null,
    id_ciudad int not null,
    id_genero int not null,
    nombre char(20) not null,
    apellido char(20) not null,
    dni int not null unique,
    fecha_nacimiento date,
    direccion char(50),
    eliminado bit not null default(0),
    constraint fk_tipo_cliente foreign key (id_tipo_de_cliente) references ddbba.TipoDeCliente(id),
    constraint fk_ciudad foreign key (id_ciudad) references ddbba.Ciudad(id),
    constraint fk_genero_cliente foreign key (id_genero) references ddbba.Genero(id)
);
go

create table ddbba.Sucursal (
    id int identity(1,1) primary key,
    nombre char(20),
    localidad char(20)
);
go

create table ddbba.Empleado (
    id int identity(1,1) primary key,
    id_genero int,
    id_sucursal int,
    nombre char(20) not null,
    apellido char(20) not null,
    cuil int not null unique,
    fecha_ingreso date not null,
    fecha_egreso date,
    eliminado bit not null default(0),
    direccion char(50),
    constraint fk_genero_empleado foreign key (id_genero) references ddbba.Genero(id),
    constraint fk_sucursal foreign key (id_sucursal) references ddbba.Sucursal(id)
);
go

create table ddbba.MedioDePago (
    id int identity(1,1) primary key,
    descripcion char(30) not null unique
);
go

create table ddbba.Venta (
    id int identity(1,1) primary key,
    id_empleado int,
    id_sucursal int,
    id_medio_de_pago int,
    total decimal(10,2) check (total >=0),
    cantidad_de_productos int check (cantidad_de_productos >= 0),
    fecha date,
    hora time(0),
    constraint fk_empleado foreign key (id_empleado) references ddbba.Empleado(id),
    constraint fk_sucursal_venta foreign key (id_sucursal) references ddbba.Sucursal(id),
    constraint fk_medio_de_pago foreign key (id_medio_de_pago) references ddbba.MedioDePago(id)
);
go

create table ddbba.TipoDeFactura (
    id int identity(1,1) primary key,
    tipo char(1) not null unique
);
go

create table ddbba.Factura (
    id int identity(1,1) primary key,
    id_venta int,
    id_tipo_de_factura int,
    constraint fk_venta_factura foreign key (id_venta) references ddbba.Venta(id),
    constraint fk_tipo_de_factura foreign key (id_tipo_de_factura) references ddbba.TipoDeFactura(id)
);
go

create table ddbba.LineaDeProducto (
    id int identity(1,1) primary key,
    nombre char(30) not null unique
);
go

create table ddbba.Producto (
    id int identity(1,1) primary key,
    id_linea_de_producto int,
    nombre_producto char(30) not null,
    precio decimal(10,2) not null,
    constraint fk_linea_de_producto foreign key (id_linea_de_producto) references ddbba.LineaDeProducto(id)
);
go

create table ddbba.Catalogo (
    id int primary key,
    categoria char(30),
    nombre char(50),
    precio decimal(8,2),
    precio_referencia decimal(10,2),
    unidad_referencia char(2),
    fecha datetime
);
go

create table ddbba.AccesorioElectronico (
    id int identity(1,1) primary key,
    producto char(50),
    precio_unitario_dolares decimal(10,2)
);
go

create table ddbba.ProductoImportado (
    id_producto int primary key,
    cantidad_por_unidad char(40),
    nombre char(50),
    categoria char(30),
    proveedor char(50),
    precio_por_unidad decimal(10,2)
);
go

create table ddbba.LineaDeVenta (
    id int identity(1,1) primary key,
    id_venta int,
    id_producto int,
    id_catalogo int,
    id_producto_importado int,
    id_accesorio int,
    can_producto int default 0 check (can_producto >= 0),
    pre_producto decimal(10,2) default 0 check (pre_producto >= 0),
    sub_producto as (can_producto * pre_producto) persisted,
    can_catalogo int default 0 check (can_catalogo >= 0),
    pre_catalogo decimal(10,2) default 0 check (pre_catalogo >= 0),
    sub_catalogo as (can_catalogo * pre_catalogo) persisted,
    can_accesorio int default 0 check (can_accesorio >= 0),
    pre_accesorio decimal(10,2) default 0 check (pre_accesorio >= 0),
    sub_accesorio as (can_accesorio * pre_accesorio) persisted,
    can_producto_importado int default 0 check (can_producto_importado >= 0),
    pre_producto_importado decimal(10,2) default 0 check (pre_producto_importado >= 0),
    sub_producto_importado as (can_producto_importado * pre_producto_importado) persisted,
    constraint fk_venta_linea foreign key (id_venta) references ddbba.Venta(id),
    constraint fk_producto_linea foreign key (id_producto) references ddbba.Producto(id),
    constraint fk_catalogo_linea foreign key (id_catalogo) references ddbba.Catalogo(id),
    constraint fk_producto_importado_linea foreign key (id_producto_importado) references ddbba.ProductoImportado(id_producto),
    constraint fk_accesorio_linea foreign key (id_accesorio) references ddbba.AccesorioElectronico(id),
    constraint unq_venta_producto unique (id_venta, id_producto),
    constraint unq_venta_producto_importado unique (id_venta, id_producto_importado),
    constraint unq_venta_catalogo unique (id_venta, id_catalogo),
    constraint unq_venta_accesorio unique (id_venta, id_accesorio)
);
go
