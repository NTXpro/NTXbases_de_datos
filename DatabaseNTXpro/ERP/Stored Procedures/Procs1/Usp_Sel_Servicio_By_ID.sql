CREATE PROC [ERP].[Usp_Sel_Servicio_By_ID]
@ID int
AS
BEGIN

	SELECT	SER.ID											ID,
			SER.FlagISC										FlagISC,
			SER.FlagIGVAfecto								FlagIGVAfecto,
			MA.ID											IdMarca,
			T6U.ID											IdUnidadMedida,
			T5E.ID											IdExistencia,
			PC.ID											IdPlanCuenta,
			SER.Nombre										Nombre,
			T6U.CodigoSunat,
			T5E.CodigoSunat,
			MA.Nombre										NombreMarca,
			T6U.Nombre										NombreUndidadMedida,
			T5E.Nombre										NombreExistencia,
			PC.CuentaContable								CuentaContable,
			PC.Nombre										NombreCuentaContable,
			PC.CuentaContable + ' ' + PC.Nombre				NombreCompletoCuentaContable,
			SER.CodigoReferencia							Referencia,
			SER.UsuarioRegistro,
			SER.UsuarioModifico,
			SER.UsuarioElimino,
			SER.UsuarioActivo,
			SER.FechaRegistro,
			SER.FechaModificado,
			SER.FechaEliminado,
			SER.FechaActivacion
			
	FROM [ERP].[Producto] SER
	LEFT JOIN PLE.T6UnidadMedida T6U
	ON T6U.ID=SER.IdUnidadMedida
	LEFT JOIN Maestro.Marca MA
	ON MA.ID= SER.IdMarca 
	LEFT JOIN PLE.T5Existencia T5E
	ON T5E.ID=SER.IdExistencia 
	LEFT JOIN Maestro.TipoProducto TP
	ON TP.ID=SER.IdTipoProducto
	LEFT JOIN [ERP].[Empresa] EM
	ON EM.ID=SER.IdEmpresa
	LEFT JOIN [ERP].[PlanCuenta] PC
	ON PC.ID=SER.IdPlanCuenta
	WHERE SER.ID = @ID AND SER.IdTipoProducto = 2
END
