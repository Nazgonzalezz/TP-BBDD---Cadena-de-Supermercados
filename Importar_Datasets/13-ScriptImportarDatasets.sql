--Para ejecutar este script primero debio haber ejecutado el script de CreacionGeneral 

--Nos posicionamos en la base datos

use g05com2900
go

--Activamos la configuracion necesaria para utilizar  
sp_configure 'show advanced options', 1;
reconfigure;
go
sp_configure 'ad hoc distributed queries', 1;
reconfigure;
go

--Eliminamos el stored procedure para importar los datos desde el excel hasta la tabla productoimportado
--si existe 
drop procedure if exists importarproductosdesdeexcel;
go


--Stored Procedure que baja los archivos del excel a la tabla productoimportado
create procedure importarproductosdesdeexcel
as
begin
    -- ruta del archivo excel
    declare @rutaarchivo nvarchar(255) = 'C:\Users\arace\Documents\SQL Server Management Studio\g05com2900\TP_integrador_Archivos\Productos';
    -- consulta para importar datos desde excel
    declare @sql nvarchar(max) = '
    insert into productos.ProductoImportado (id_producto, cantidad_por_unidad, nombre, categoria, proveedor, precio_por_unidad)
    select id_producto, cantidad_por_unidad, nombre, categoria, proveedor, precio_por_unidad
    from openrowset(''microsoft.ace.oledb.12.0'',
                    ''excel 12.0;database=' + @rutaarchivo + ';hdr=yes'',
                    ''select * from [hoja1$]'')';
    exec sp_executesql @sql;
end;
go

select * 
from productos.productoimportado ;;
go 


