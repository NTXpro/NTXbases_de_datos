CREATE PROC [ERP].[Usp_Sel_RegistroCompraPLE_NoDomiciliado]
@IdEmpresa INT,
@IdPeriodo INT,
@idAnio VARCHAR(4),
@idMes VARCHAR(2)
AS
BEGIN

DECLARE @FechaPeriodo DATE = DATEADD(day, -1, DATEADD(month, 1, CAST(@IdAnio+@idMes+'01' AS DATE)))

SELECT
CONCAT(@idAnio,@idMes,'00')                                                 Periodo,			--1
CONCAT('05',RIGHT('000000' + CAST(A.Orden AS VARCHAR(8)), 7))				Asiento,			--2
CONCAT('M',CONCAT('05',RIGHT('000000' + CAST(A.Orden AS VARCHAR(8)), 7)))	Asiento2,			--3
C.FechaEmision,																FechaEmision,		--4
T10.CodigoSunat																TipoComprobante,	--5
C.Serie																		Serie,				--6
C.Numero																	Documento,			--7
'0.00'																		Col8,				--8(Valor de las adquisiones)
'0.00'																		Col9,				--9(Otros conceptos)
CASE WHEN C.IdMoneda = 1 THEN
	C.Total
ELSE
	C.Total * C.TipoCambio
END																			Total ,				--10(Total)
''																			Col11,				--11(TipoComprobante de Pago que sustente el crédito fiscal)
''																			Col12,				--12(DUA)
''																			Col13,				--13(Año de Emision de la DUA)
''																			Col14,				--14(Número del comprobante de pago o documento o número de orden del formulario físico o virtual donde conste el pago del impuesto, tratándose de la utilización de servicios prestados por no domiciliados u otros, número de la DUA o de la DSI, que sustente el crédito fiscal.)
'0.00'																		Col15,				--15(Monto de retención IGV)
M.CodigoSunat																Moneda,				--16(Código Sunat Moneda) // OBLIGATORIO
C.TipoCambio																TipoCambio,			--17(TipoCambio)
PA.CodigoSunat																Pais,				--18(Pais)
E.Nombre																	Proveedor,			--19(NombreProveedor)
ES.Direccion																Direccion,			--20(Direccion)
ETD.NumeroDocumento															NumeroDocumento,	--21(NumeroDocumento)
''																			Col22,				--22(Número de identificación fiscal del beneficiario efectivo de los pagos)
''																			Col23,				--23
''																			Col24,				--24
''																			Col25,				--25
'0.00'																		RentaBruta,			--26(RentaBruta)
'0.00'																		Col27,				--27(Deducción / Costo de Enajenación de bienes de capital)
'0.00'																		RentaNeta,			--28(RentaNeta)
'0.00'																		TasaRetencion,		--29(Tasa de retención)
'0.00'																		ImpustoRetenido,	--30(Impuesto retenido)
'00'																		Convenio,			--31(Convenios para evitar la doble imposición)
''																			Col32,				--32(Exoneración aplicada)
'00'																		TipoRenta,			--33(TipoRenta)
''																			Col34,				--34(Modalidad del servicio prestado por el no domiciliado)
''																			Col35,				--35(Aplicación del penultimo parrafo del Art. 76° de la Ley del Impuesto a la Renta)
CASE WHEN CAST(C.FechaEmision AS DATE) <= CAST(@FechaPeriodo AS DATE) THEN
	0
ELSE
	9
END																			Oportunidad			 --36(Estado que identifica la oportunidad de la anotación o indicación si ésta corresponde a un ajuste)
FROM ERP.Compra C
INNER JOIN ERP.Asiento A
ON C.IdAsiento = A.ID
INNER JOIN PLE.T10TipoComprobante T10
ON C.IdTipoComprobante = T10.ID
INNER JOIN ERP.Proveedor P
ON C.IdProveedor = P.ID
INNER JOIN ERP.Entidad E
ON E.ID = P.IdEntidad
INNER JOIN ERP.Establecimiento ES
ON ES.IdEntidad = E.ID
INNER JOIN PLE.T35Paises PA
ON PA.ID = ES.IdPais
INNER JOIN ERP.EntidadTipoDocumento ETD
ON E.ID = ETD.IdEntidad
INNER JOIN PLE.T2TipoDocumento T2
ON ETD.IdTipoDocumento = T2.ID
LEFT JOIN ERP.CompraDetraccion CD
ON C.ID = CD.IdCompra
INNER JOIN ERP.Periodo PR
ON C.IdPeriodo = PR.ID
INNER JOIN Maestro.Anio An
ON PR.IdAnio = An.ID
INNER JOIN Maestro.Mes Ms
ON PR.IdMes = Ms.ID
INNER JOIN Maestro.Moneda M
ON C.IdMoneda = M.ID
INNER JOIN Maestro.TipoIGV TI
ON C.IdTipoIGV = TI.ID
LEFT JOIN 
(SELECT CRI.IdCompraReferencia, C.FechaEmision FechaRef, T10.CodigoSunat CodigoSunatRef,C.Serie SerieRef,C.Numero NumeroRef ,CRI.IdCompra FROM ERP.Compra C
INNER JOIN ERP.CompraReferenciaInterna CRI
ON C.ID = CRI.IdCompraReferencia
INNER JOIN PLE.T10TipoComprobante T10
ON C.IdTipoComprobante = T10.ID
) B
ON C.ID = B.IdCompra
WHERE C.IdEmpresa = @IdEmpresa AND C.IdPeriodo = @IdPeriodo AND C.FlagBorrador = 0 AND C.Flag = 1 AND C.IdTipoComprobante IN (SELECT ID FROM PLE.T10TipoComprobante WHERE CodigoSunat IN ('00','91','97','98') AND FlagSunat = 1)
ORDER BY A.ORDEN ASC
END