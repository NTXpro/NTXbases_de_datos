CREATE PROC [ERP].[Usp_Sel_Producto_By_ID] 
@ID int
AS
BEGIN

	SELECT	PRO.ID											ID,
			PRO.FlagIGVAfecto								FlagIGVAfecto,
			PRO.FlagISC										FlagISC,
			MA.ID											IdMarca,
			T6U.ID											IdUnidadMedida,
			T5E.ID											IdExistencia,

			PC.ID											IdPlanCuenta,
			PCC.ID											IdPlanCuentaCompra,

			PRO.Nombre										Nombre,
			T6U.CodigoSunat									CodigoSunatUnidadMedida,
			T5E.CodigoSunat									CodigoSunatExistencia,
			MA.Nombre										NombreMarca,
			T6U.Nombre										NombreUndidadMedida,
			T5E.Nombre										NombreExistencia,
			PC.CuentaContable								CuentaContable,
			PC.Nombre										NombrePlanCuenta,
			PC.CuentaContable + ' ' + PC.Nombre				NombreCompletoCuentaContable,

			PCC.CuentaContable								CuentaContableCompra,
			PCC.Nombre										NombrePlanCuentaCompra,
			PCC.CuentaContable + ' ' + PC.Nombre			NombreCompletoCuentaContableCompra,

			PRO.CodigoReferencia							Referencia,
			PRO.UsuarioRegistro,
			PRO.UsuarioModifico,
			PRO.UsuarioElimino,
			PRO.UsuarioActivo,
			PRO.FechaRegistro,
			PRO.FechaModificado,
			PRO.FechaEliminado,
			PRO.FechaActivacion,
			PRO.NombreImagen,
			PRO.Imagen,
			PRO.Peso,
			PRO.StockDeseable,
			PRO.StockMinimo,
			FP.IdFamilia,
			PRO.IdTipoProducto
	FROM ERP.Producto PRO
	LEFT JOIN PLE.T6UnidadMedida T6U
	ON T6U.ID=PRO.IdUnidadMedida
	LEFT JOIN Maestro.Marca MA
	ON MA.ID= PRO.IdMarca 
	LEFT JOIN PLE.T5Existencia T5E
	ON T5E.ID=PRO.IdExistencia 
	LEFT JOIN Maestro.TipoProducto TP
	ON TP.ID=PRO.IdTipoProducto
	LEFT JOIN ERP.Empresa EM
	ON EM.ID=PRO.IdEmpresa
	LEFT JOIN ERP.PlanCuenta PC
	ON PC.ID=PRO.IdPlanCuenta
	LEFT JOIN ERP.PlanCuenta PCC
	ON PCC.ID = PRO.IdPlanCuentaCompra
	LEFT JOIN ERP.FamiliaProducto FP
	ON FP.IdProducto = PRO.ID
	WHERE PRO.ID = @ID
END