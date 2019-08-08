
create PROC [ERP].[Usp_Ins_ClienteVarios_Empresa]
@IdEmpresa INT
AS
BEGIN
	
	INSERT INTO ERP.Cliente(
						   [IdEntidad]
						  ,[IdEmpresa]
						  ,[IdVendedor]
						  ,[IdTipoRelacion]
						  ,[FechaRegistro]
						  ,[FechaEliminado]
						  ,[FlagBorrador]
						  ,[Flag]
						  ,[FechaModificado]
						  ,[UsuarioRegistro]
						  ,[UsuarioModifico]
						  ,[UsuarioElimino]
						  ,[UsuarioActivo]
						  ,[FechaActivacion]
						  ,[Correo]
						  ,[DiasVencimiento]
						  ,[FlagClienteBoleta]
	)
	SELECT TOP 1 [IdEntidad]
				,@IdEmpresa
				,[IdVendedor]
				,[IdTipoRelacion]
				,[FechaRegistro]
				,[FechaEliminado]
				,[FlagBorrador]
				,[Flag]
				,[FechaModificado]
				,[UsuarioRegistro]
				,[UsuarioModifico]
				,[UsuarioElimino]
				,[UsuarioActivo]
				,[FechaActivacion]
				,[Correo]
				,[DiasVencimiento]
				,[FlagClienteBoleta]
		FROM ERP.Cliente WHERE FlagClienteBoleta = 1
 
END
