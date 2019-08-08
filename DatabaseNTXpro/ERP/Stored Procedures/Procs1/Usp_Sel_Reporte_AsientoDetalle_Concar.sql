
CREATE PROC [ERP].[Usp_Sel_Reporte_AsientoDetalle_Concar]
@IDS VARCHAR(MAX)
AS
BEGIN

SELECT '06' SubDiario,
	   RIGHT('00' + LTRIM(RTRIM(MONTH(AD.Fecha))), 2)  + RIGHT('0000' + LTRIM(RTRIM(A.Orden)), 4) NumeroComprobante,
	   FORMAT(AD.Fecha,'dd/MM/yyyy') FechaComprobante,
	   'MN' CodigoMoneda,
	   AD.Nombre GlosaPrincipal,
	   CAST(A.TipoCambio AS DECIMAL(14,2)) TipoCambio,
	   'V' TipoConversion,
	   CASE WHEN A.IdMoneda = 1 THEN
			'N'
	   ELSE
			'S'
	   END FlagConversionMoneda,
	   FORMAT(AD.Fecha,'dd/MM/yyyy') FechaTipoCambio,
	   PC.CuentaContable CuentaContable,
	   CASE WHEN SUBSTRING(PC.CuentaContable,0,3) = '40' THEN
	    '110'
	   ELSE
		ETD.NumeroDocumento
	   END CodigoAnexo,
	   '300' CentroCosto,
	   DH.Abreviatura DebeHaber,
	   CAST(AD.ImporteSoles AS DECIMAL(14,2)) ImporteOriginal,
	   CAST(AD.ImporteDolares AS DECIMAL(14,2)) ImporteDolares,
	   CAST(AD.ImporteSoles AS DECIMAL(14,2)) ImporteSoles,
--	   TC.CodigoSunat TipoDocumento,
		CASE WHEN C.IdTipoComprobante = 4 OR C.IdTipoComprobante = 189 THEN --BOLETA
			'BV'
		WHEN C.IdTipoComprobante = 2 OR C.IdTipoComprobante = 190 THEN --FACTURA
			'FT' 
		WHEN C.IdTipoComprobante = 8 THEN
			'NA' 
		WHEN C.IdTipoComprobante = 9 THEN
			'ND'
		END TipoDocumento,
	   RIGHT('00000000000000000000' + LTRIM(RTRIM(C.Documento)), 20) NumeroDocumento,
	   --'' NumeroDocumento,
	   FORMAT(AD.Fecha,'dd/MM/yyyy') FechaDocumento,
	   FORMAT(AD.Fecha,'dd/MM/yyyy') FechaVencimiento,
	   --'' FechaDocumento,
	   --'' FechaVencimiento,
	   '' CodigoArea,
	   AD.Nombre GlosaDetalle,
	   '' CodigoAnexoAuxiliar,
	   '' MedioPago,
	   '' TipoDocumentoReferencia,
	   '' NumeroDocumentoReferencia,
	   '' FechaDocumentoReferencia,
	   '' NumeroMaquinaRegistradoraDocRef,
	   CAST(0 AS DECIMAL(14,2)) BaseImponibleDocumentoReferencia,
	   CAST(0 AS DECIMAL(14,2)) IGVDocumentoProvision,
	   '' TipoReferenciaMQ,
	   '' NumeroSerieCajaRegistradora,
	   --FORMAT(AD.Fecha,'dd/MM/yyyy') FechaOperacion,
	   '' FechaOperacion,
	   '' TipoTasa,
	   CAST(0 AS DECIMAL(14,2)) TasaDetraccionPercepcion,
	   CAST(0 AS DECIMAL(14,2)) ImporteBaseDetraccionPercepcionDolares,
	   CAST(0 AS DECIMAL(14,2)) ImporteBaseDetraccionPercepcionSoles,
	   'V' TipoCambioF,
	   CAST(0 AS DECIMAL(14,2)) ImporteIGVSNCreditoFiscal
FROM ERP.AsientoDetalle AD
INNER JOIN ERP.Asiento A ON A.ID = AD.IdAsiento
INNER JOIN ERP.Comprobante C ON C.IdAsiento = AD.IdAsiento
LEFT JOIN ERP.Cliente CLI ON CLI.ID = C.IdCliente
LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = CLI.IdEntidad
--INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = C.IdTipoComprobante
INNER JOIN Maestro.DebeHaber DH ON DH.ID = AD.IdDebeHaber
LEFT JOIN ERP.PlanCuenta PC ON PC.ID = AD.IdPlanCuenta
WHERE AD.IdAsiento IN (SELECT DATA FROM [ERP].[Fn_SplitContenido](@IDS,','))

END

