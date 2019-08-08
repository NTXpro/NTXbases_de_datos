CREATE PROC [ERP].[Usp_Sel_PlanCuenta_By_ID] --1
@ID int
AS
BEGIN

	SELECT	PC.ID											ID,
			MO.ID											IdMoneda,
			TC.ID											IdTipoCambio,
			CB.ID											IdColumnaBalance,
			GR.ID											IdGrado,
			GR.Longitud										Longuitud,
			MO.Nombre										NombreMoneda,
			TC.Nombre										NombreTipoCambio,
			CB.Nombre										NombreColumnaBase,
			GR.Nombre										NombreGrado,
			PC.CuentaContable								CuentaContable,
			PC.Nombre										NombreCuentaContable,
			PC.EstadoAnalisis								EstadoAnalisis,
			PC.EstadoProyecto								EstadoProyecto,
			PC.CuentaContable + ' ' + PC.Nombre				NombreCompletoCuentaContable,
			PC.UsuarioRegistro,
			PC.UsuarioModifico,
			PC.UsuarioElimino,
			PC.UsuarioActivo,
			PC.FechaRegistro,
			PC.FechaModificado,
			PC.FechaEliminado,
			PC.FechaActivacion
	FROM ERP.PlanCuenta PC
	LEFT JOIN Maestro.Grado GR
	ON GR.ID = PC.IdGrado
	LEFT JOIN Maestro.Moneda MO
	ON MO.ID = PC.IdMoneda
	LEFT JOIN Maestro.TipoCambio TC
	ON TC.ID= PC.IdTipoCambio
	LEFT JOIN Maestro.ColumnaBalance CB
	ON CB.ID = PC.IdColumnaBalance
	LEFT JOIN ERP.Empresa EM
	ON EM.ID = PC.IdEmpresa
	WHERE PC.ID = @ID
END
