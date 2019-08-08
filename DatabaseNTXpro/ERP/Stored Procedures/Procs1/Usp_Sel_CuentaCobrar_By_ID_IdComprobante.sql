

CREATE PROC [ERP].[Usp_Sel_CuentaCobrar_By_ID_IdComprobante]
@Id INT

AS
BEGIN
	SELECT *
FROM ERP.COMPROBANTECUENTACOBRAR CB
     INNER JOIN ERP.CUENTACOBRAR C ON C.ID = CB.IdCuentaCobrar
     INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
     LEFT JOIN ERP.Cliente CLI ON CLI.IdEntidad = E.ID
     LEFT JOIN ERP.TipoComprobantePlanCuenta TCPC ON TCPC.IdEmpresa = 1
                                                     AND TCPC.IdTipoComprobante = C.IdTipoComprobante
                                                     AND TCPC.IdTipoRelacion = CLI.idTipoRelacion
                                                     AND TCPC.IdMoneda = C.IdMoneda
                                                     AND TCPC.IdSistema = 2
                                                     AND IdAnio =
(
    SELECT ID
    FROM Maestro.Anio
    WHERE Nombre = YEAR(C.Fecha)
)
     LEFT JOIN ERP.PlanCuenta PC ON PC.ID = TCPC.IdPlanCuenta
     INNER JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
WHERE IdComprobante = @Id
      AND C.Flag = 1;

END