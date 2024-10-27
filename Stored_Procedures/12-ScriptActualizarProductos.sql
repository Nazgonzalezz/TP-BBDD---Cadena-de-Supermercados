--Para ejecutar este script primero debio haber ejecutado el script de CreacionGeneral 

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos el store procedure para actualizar la descripcionde la tabla Producto del esquema productos
create procedure actualizarPrecioProducto
    @id int,
    @nuevoPrecio decimal(10,2)
as
begin
    -- Corroboramos si existe el id
    if exists (select 1 from productos.producto where id = @id)
    begin
        update productos.producto
        set precio = @nuevoPrecio
        where id = @id;
    end
    else
    begin
        print 'El id ingresado no existe';
    end
end;
go


--Creamos el store procedure para actualizar los precios la tabla Catalogo del esquema productos
create procedure actualizarCatalogo
    @id int,
    @nuevoPrecio decimal(8,2),
    @nuevoPrecioReferencia decimal(10,2),
    @nuevaUnidadReferencia char(2)
as
begin
    -- Corroboramos si existe el id
    if exists (select 1 from productos.catalogo where id = @id)
    begin
        update productos.catalogo
        set precio = @nuevoPrecio,
            precio_referencia = @nuevoPrecioReferencia,
            unidad_referencia = @nuevaUnidadReferencia
        where id = @id;
    end
    else
    begin
        print 'El id ingresado no existe';
    end
end;
go

--Creamos el store procedure para actualizar los precio por unidad la tabla productoimportado
--del esquema productos
create procedure actualizarPrecioPorUnidad
    @id_producto int,
    @nuevoPrecioPorUnidad decimal(10,2)
as
begin
    -- Corroboramos si existe el id
    if exists (select 1 from productos.productoimportado where id_producto = @id_producto)
    begin
        update productos.productoimportado
        set precio_por_unidad = @nuevoPrecioPorUnidad
        where id_producto = @id_producto;
    end
    else
    begin
        print 'El id ingresado no existe';
    end
end;
go


