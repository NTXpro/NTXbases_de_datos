
CREATE PROCEDURE [ERP].[Usp_Upd_T12TipoOperacion]-- 
@ID INT,
@Nombre varchar(250),
@CodigoSunat varchar(2),
@IdTipoMovimiento INT,
@UsuarioModifico varchar(250),
@FechaModificado datetime,
@FlagSunat bit,
@FlagCostear bit,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	UPDATE [PLE].[T12TipoOperacion] SET 
		   [Nombre] = @Nombre
		  ,[CodigoSunat] = @CodigoSunat
		  ,[IdTipoMovimiento] = @IdTipoMovimiento
		  ,[UsuarioModifico] = @UsuarioModifico
		  ,[FechaModificado] = @FechaModificado
		  ,[FlagSunat] = @FlagSunat
		  ,[FlagCostear] = @FlagCostear
		  ,[FlagBorrador] = @FlagBorrador
		  ,[Flag] = @Flag
	WHERE ID = @ID
	SELECT @ID;
END
