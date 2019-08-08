CREATE PROC [ERP].[Usp_Sel_CuentaCobrarPagar_By_IdEntidad_IdTipoComprobantePlanCuenta] 
@IdEmpresa  INT, 
@IdEntidad  INT, 
@TipoCambio DECIMAL(14, 5)
AS
     BEGIN
         DECLARE @IdMonedaSoles INT= 1;
         DECLARE @IdMonedaDolares INT= 2;

         --IF @IdSistema = 4 ---COMPRA
         --BEGIN
         SELECT C.ID, 
                C.IdTipoComprobante, 
                TC.Nombre NombreTipoComprobante, 
                C.Serie, 
                C.Numero, 
                C.IdMoneda, 
                M.Nombre NombreMoneda, 
                CAST(@TipoCambio AS DECIMAL(14, 5)) TipoCambio, 
                C.Fecha,
                ------------==================== SALDOS SOLES  ====================------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN C.Total
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN CAST((C.Total * @TipoCambio) AS DECIMAL(14, 5))
                END SaldoInicialSoles,
                -------------------------------------------------------------------------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](C.ID)
         ) AS DECIMAL(14, 5))
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](C.ID) * @TipoCambio
         ) AS DECIMAL(14, 5))
                END SaldoSoles,
         ------------==================== SALDOS DOLARES  ====================------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN C.Total
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN CAST((C.Total / @TipoCambio) AS DECIMAL(14, 5))
                END SaldoInicialDolares,
         ---------------------------------------------------------------------------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](C.ID)
         ) AS DECIMAL(14, 5))
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](C.ID) / @TipoCambio
         ) AS DECIMAL(14, 5))
                END SaldoDolares, 
                (CASE
                     WHEN C.IdMoneda = @IdMonedaSoles
                     THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](C.ID)
         ) AS DECIMAL(14, 2))
                     ELSE CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](C.ID)
         ) AS DECIMAL(14, 2))
                 END) SaldoOriginal, 
                TCPC.IdPlanCuenta IdPlanCuenta, 
                PC.CuentaContable CuentaContable, 
                TCPC.Nombre NombreTipoComprobantePlanCuenta, 
                TCPC.ID IdTipoComprobantePlanCuenta, 
                'P' OPERACION, 
                C.IdDebeHaber, 
                CPO.Nombre Origen
         FROM ERP.CuentaPagar C
              INNER JOIN Maestro.CuentaPagarOrigen CPO ON CPO.ID = C.IdCuentaPagarOrigen
              INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
              LEFT JOIN ERP.Proveedor P ON P.IdEntidad = E.ID
              INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = C.IdTipoComprobante
              LEFT JOIN ERP.TipoComprobantePlanCuenta TCPC ON TCPC.IdEmpresa = @IdEmpresa
                                                              AND TCPC.IdTipoComprobante = C.IdTipoComprobante
                                                              AND TCPC.IdTipoRelacion = P.idTipoRelacion
                                                              AND TCPC.IdMoneda = C.IdMoneda
                            AND TCPC.IdSistema = 4

                                                              /*COMPRAS*/

                                                              AND TCPC.IdAnio =
         (
             SELECT IdAnio
             FROM ERP.Periodo
             WHERE ID = C.IdPeriodo
         )
              LEFT JOIN ERP.PlanCuenta PC ON PC.ID = TCPC.IdPlanCuenta
              INNER JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
         WHERE(P.FlagBorrador = 0
               AND P.IdEmpresa = @IdEmpresa)
              AND E.ID = @IdEntidad
              AND C.Flag = 1
              AND C.IdEmpresa = @IdEmpresa
              AND (CASE
                       WHEN C.IdMoneda = @IdMonedaSoles
                       THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](C.ID)
         ) AS DECIMAL(14, 2))
                       ELSE CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](C.ID)
         ) AS DECIMAL(14, 2))
                   END) != 0
    AND ((C.IdTipoComprobante = 178
          AND C.IdDebeHaber = 2)
         OR (C.IdTipoComprobante IS NOT NULL
             AND C.IdTipoComprobante != 178))
--END
--ELSE
--BEGIN
         UNION
         SELECT C.ID, 
                C.IdTipoComprobante, 
                TC.Nombre NombreTipoComprobante, 
                C.Serie, 
                C.Numero, 
                C.IdMoneda, 
                M.Nombre NombreMoneda, 
                @TipoCambio TipoCambio, 
                C.Fecha,
                ------------==================== SALDOS SOLES  ====================------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN C.Total
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN(C.Total * @TipoCambio)
                END SaldoInicialSoles,
                -------------------------------------------------------------------------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeSolesPorAjuste](C.ID)
         ) AS DECIMAL(14, 5))
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeDolaresPorAjuste](C.ID) * @TipoCambio
         ) AS DECIMAL(14, 5))
                END SaldoSoles,
------------==================== SALDOS DOLARES  ====================------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN C.Total
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN CAST((C.Total / @TipoCambio) AS DECIMAL(14, 5))
                END SaldoInicialDolares,
---------------------------------------------------------------------------------
                CASE
                    WHEN C.IdMoneda = @IdMonedaDolares
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeDolaresPorAjuste](C.ID)
         ) AS DECIMAL(14, 5))
                    WHEN C.IdMoneda = @IdMonedaSoles
                    THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeSolesPorAjuste](C.ID) / @TipoCambio
         ) AS DECIMAL(14, 5))
                END SaldoDolares, 
                (CASE
                     WHEN C.IdMoneda = @IdMonedaSoles
                     THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeSolesPorAjuste](C.ID)
         ) AS DECIMAL(14, 2))
                     ELSE CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeDolaresPorAjuste](C.ID)
         ) AS DECIMAL(14, 2))
                 END) SaldoOriginal, 
                TCPC.IdPlanCuenta IdPlanCuenta, 
                PC.CuentaContable CuentaContable, 
                TCPC.Nombre NombreTipoComprobantePlanCuenta, 
                TCPC.ID IdTipoComprobantePlanCuenta, 
                'C' OPERACION, 
                C.IdDebeHaber, 
                CPO.Nombre Origen
         FROM ERP.CuentaCobrar C
              INNER JOIN Maestro.CuentaCobrarOrigen CPO ON CPO.ID = C.IdCuentaCobrarOrigen
              INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
              LEFT JOIN ERP.Cliente CLI ON CLI.IdEntidad = E.ID
              INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = C.IdTipoComprobante
              LEFT JOIN ERP.TipoComprobantePlanCuenta TCPC ON TCPC.IdEmpresa = @IdEmpresa
                                                              AND TCPC.IdTipoComprobante = C.IdTipoComprobante
                                                              AND TCPC.IdTipoRelacion = CLI.idTipoRelacion
                                                              AND TCPC.IdMoneda = C.IdMoneda
                                                              AND TCPC.IdSistema = 2

                                                              /*VENTAS*/

                                                              AND IdAnio =
         (
             SELECT ID
             FROM Maestro.Anio
             WHERE Nombre = YEAR(C.Fecha)
         )
              LEFT JOIN ERP.PlanCuenta PC ON PC.ID = TCPC.IdPlanCuenta
              INNER JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
         WHERE(CLI.FlagBorrador = 0
               AND CLI.IdEmpresa = @IdEmpresa)
              AND C.IdEntidad = @IdEntidad
              AND C.Flag = 1
              AND C.IdEmpresa = @IdEmpresa
              AND (CASE
                       WHEN C.IdMoneda = @IdMonedaSoles
                       THEN CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeSolesPorAjuste](C.ID)
         ) AS DECIMAL(14, 2))
                       ELSE CAST(
         (
             SELECT [ERP].[SaldoTotalCuentaCobrarDeDolaresPorAjuste](C.ID)
         ) AS DECIMAL(14, 2))
                   END) != 0
AND ((C.IdTipoComprobante = 178
      AND C.IdDebeHaber = 1)
     OR (C.IdTipoComprobante IS NOT NULL
         AND C.IdTipoComprobante != 178));
         --END

     END;