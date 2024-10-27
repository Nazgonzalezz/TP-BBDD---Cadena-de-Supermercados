--Para ejecutar este script primero debio haber ejecutado el script de CreacionGeneral 

--Nos posicionamos en la base datos
use g05com2900
go


--Creamos el store procedure para actualizar la descripcionde la tabla MedioDePago del esquema Ventas
create procedure actualizarDescripcionMedioDePago
    @id int,
    @nuevaDescripcion char(30)
as
begin
    -- Corroboramos si existe el id
    if exists (select 1 from ventas.mediodepago where id = @id)
    begin
        update ventas.mediodepago
        set descripcion = @nuevaDescripcion
        where id = @id;
    end
    else
    begin
        print 'El id ingresado no existe';
    end
end;
go
