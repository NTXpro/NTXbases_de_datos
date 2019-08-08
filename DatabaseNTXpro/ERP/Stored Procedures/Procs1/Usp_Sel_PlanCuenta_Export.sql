CREATE PROCEDURE [ERP].[Usp_Sel_PlanCuenta_Export]
@Flag bit,
@IdEmpresa int
AS
BEGIN
SELECT          
			
			PC.ID,
			MO.Nombre										NombreMoneda,
			TC.Nombre										NombreTipoCambio,
			CB.Nombre										NombreColumnaBase,
			GR.Nombre										NombreGrado,
			PC.CuentaContable								CuentaContable,
			PC.Nombre										NombreCuentaContable,
			PC.EstadoAnalisis								EstadoAnalisis,
			PC.EstadoProyecto								EstadoProyecto,
			PC.FechaEliminado,
			PC.FechaRegistro
		FROM [ERP].[PlanCuenta] PC
		INNER JOIN Maestro.Grado GR
		ON GR.ID = PC.IdGrado
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = PC.IdMoneda
		INNER JOIN Maestro.TipoCambio TC
		ON TC.ID= PC.IdTipoCambio
		INNER JOIN Maestro.ColumnaBalance CB
		ON CB.ID = PC.IdColumnaBalance
		LEFT JOIN ERP.Empresa EM
		ON EM.ID = PC.IdEmpresa
		WHERE PC.Flag = @Flag AND PC.FlagBorrador = 0 AND PC.IdEmpresa = @IdEmpresa
END
