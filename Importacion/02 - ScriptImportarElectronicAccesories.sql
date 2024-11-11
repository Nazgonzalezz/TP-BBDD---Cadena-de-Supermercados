use g05com2900;
go

create procedure importar_accesorios_con_tipo_cambio
    @rutaarchivo nvarchar(255),    -- Ruta del archivo Excel
    @tipodecambio decimal(10,2)     -- Tipo de cambio de dólares a pesos (a ser pasado por la aplicación externa o servicio API)
as
begin
    -- Declarar la variable para la conexión al archivo Excel
    declare @sql nvarchar(max);

    -- Crear la cadena de la consulta OPENROWSET
    set @sql = 'select Product, [Precio Unitario en Dolares] from openrowset(' +
               '''microsoft.ace.oledb.12.0'', ' +
               '''excel 12.0 xml;hdr=yes;database=' + @rutaarchivo + ''', ' +
               '''select Product, [Precio Unitario en Dolares] from [Hoja1$]'')';

    -- Ejecutar la consulta dinámica para cargar el archivo Excel
    exec sp_executesql @sql;

    -- Crear la tabla temporal para almacenar los datos del archivo Excel
    select *
    into #tempimport
    from openrowset(
        'microsoft.ace.oledb.12.0',
        'excel 12.0 xml;hdr=yes;database=' + @rutaarchivo,
        'select Product, [Precio Unitario en Dolares] from [Hoja1$]'
    );

    -- Verificar si la tabla productos.AccesorioElectronico existe, y si no, crearla
    if not exists (select * from sys.tables where name = 'AccesorioElectronico' and schema_name(schema_id) = 'productos')
    begin
        create table productos.AccesorioElectronico (
            id int identity(1,1) primary key,
            producto char(50),
            precio_unitario_pesos decimal(10, 2)
        );
    end

    -- Insertar los registros desde la tabla temporal a productos.AccesorioElectronico sin duplicados
    insert into productos.AccesorioElectronico (producto, precio_unitario_dolares)
    select 
        producto, 
        [precio_unitario_en_dolares] * @tipodecambio  -- Convertir el precio de dólares a pesos
    from #tempimport as temp
    where not exists (
        select 1
        from productos.AccesorioElectronico as p
        where p.producto = temp.Product
    );

    -- Limpiar la tabla temporal
    drop table #tempimport;
end;


-----------------------------------------------------------------------------------------------------------------


create or alter procedure productos.ImportarAccesoriosElectronicos
    @rutaxlsx nvarchar(max)
as
begin

    create table productos.#AccesorisElectronicosTemp(
		product varchar(75),
		precio_unitario_dolares decimal(10,2),
		constraint pk_accesorios_electronicos_temp primary key (product, precio_unitario_dolares)
    );

	declare @sql nvarchar(max);

    set @sql = '
        insert into productos.#AccesorisElectronicosTemp(product, precio_unitario_dolares)
        select product, [precio unitario en dolares] as precio_unitario_dolares
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [sheet1$]''
        )';


    exec sp_executesql @sql;

    drop table if exists productos.#AccesorisElectronicosTemp;
    
end;
go

exec productos.ImportarAccesoriosElectronicos @rutaxlsx = 'D:\Escritorio\2do cuatrimestre 2024\Bases de datos aplicada\TP BDA\TP_integrador_Archivos\Productos\Electronic accessories.xlsx'

sp_configure 'show advanced options', 1;
RECONFIGURE;

sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

SP_CONFIGURE 'show advanced options', 1; 
GO 
RECONFIGURE; 
SP_CONFIGURE 'Ad Hoc Distributed Queries', 1; 
GO 
RECONFIGURE; 
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1   
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParam', 1

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1;
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1;
