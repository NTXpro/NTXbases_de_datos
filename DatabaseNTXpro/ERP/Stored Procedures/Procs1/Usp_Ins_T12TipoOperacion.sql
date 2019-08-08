
CREATE PROCEDURE [ERP].[Usp_Ins_T12TipoOperacion]
@Nombre varchar(250),
@CodigoSunat varchar(2),
@IdTipoMovimiento INT,
@UsuarioRegistro varchar(250),
@FechaRegistro datetime,
@FlagSunat bit,
@FlagCostear bit,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	INSERT INTO [PLE].[T12TipoOperacion]
           ([Nombre]
           ,[CodigoSunat]
		   ,[IdTipoMovimiento]
           ,[UsuarioRegistro]
           ,[FechaRegistro]
           ,[FlagSunat]
		   ,[FlagCostear]
           ,[FlagBorrador]
           ,[Flag])
     VALUES
           (@Nombre
           ,@CodigoSunat
		   ,@IdTipoMovimiento
           ,@UsuarioRegistro
           ,@FechaRegistro
           ,@FlagSunat
		   ,@FlagCostear
           ,@FlagBorrador
           ,@Flag)
	SELECT CAST(SCOPE_IDENTITY() AS int)
END
