CREATE PROC [ERP].[Usp_Sel_RegistoVentas_Pagination] --1,1,2017,1,1000,'RazonSocial','DESC',5
@IdEmpresa INT ,
@Mes INT,
@Anio INT,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS
BEGIN

		WITH RegistroVentas AS
		(
				SELECT ROW_NUMBER() OVER
				(ORDER BY 

					--ASC
						CASE WHEN (@SortType = 'Serie' AND @SortDir = 'ASC') THEN LTRIM(C.Serie) END ASC,
						--CASE WHEN (@SortType = 'Documento' AND @SortDir = 'ASC') THEN C.Documento END ASC,
						--CASE WHEN (@SortType = 'Fecha' AND @SortDir = 'ASC') THEN C.Fecha END ASC,
						--CASE WHEN (@SortType = 'Estado' AND @SortDir = 'ASC') THEN C.IdComprobanteEstado END ASC,
						CASE WHEN (@SortType = 'Total' AND @SortDir = 'ASC') THEN C.Total END ASC,
						CASE WHEN (@SortType = 'RazonSocial' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
						
						--DESC
						CASE WHEN (@SortType = 'Serie' AND @SortDir = 'DESC') THEN LTRIM(C.Serie) END DESC,
						--CASE WHEN (@SortType = 'Documento' AND @SortDir = 'DESC') THEN C.Documento END DESC,
						--CASE WHEN (@SortType = 'Fecha' AND @SortDir = 'DESC') THEN C.Fecha END DESC,
						--CASE WHEN (@SortType = 'Estado' AND @SortDir = 'DESC') THEN C.IdComprobanteEstado END DESC,
						CASE WHEN (@SortType = 'Total' AND @SortDir = 'DESC') THEN C.Total END DESC,
						CASE WHEN (@SortType = 'RazonSocial' AND @SortDir = 'DESC') THEN EN.Nombre END DESC
						--CASE WHEN (@SortType = 'NumeroDocumentoCliente' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
						--CASE WHEN (@SortType = 'NombreTipoDocumento' AND @SortDir = 'DESC') THEN TD.Nombre END DESC,
						--CASE WHEN (@SortType = 'Inicio' AND @SortDir = 'DESC') THEN CAST(C.Fecha AS VARCHAR(20))+C.Serie+C.Documento END DESC
				
				)
				AS ROWNUMBER,
					 C.Fecha					FechaEmision,
					 C.Fecha					FechaVencimiento,
					 T10.CodigoSunat			Tipo,
					 C.Serie					Serie,					  
					 C.Documento				Numero,
					 T2.Abreviatura				Documento,
					 ETD.NumeroDocumento		RUC, 
					 EN.Nombre					RazonSocial, 
					Sum(iif(CE.ID <> 3,(iif(C.TotalDetalleExportacion is Null, '0.00000', C.TotalDetalleExportacion)),'0.00000'))	ValorFacturadoExportacion,
					Sum(iif(CE.ID <> 3,(iif(M.CodigoSunat = 'PEN',CD.PrecioSubTotal,CD.PrecioSubTotal*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1)),'0.00000')) BaseImponible,
					Sum(iif(CE.ID <> 3,(iif(C.TotalDetalleAfecto is Null, '0.00000', C.TotalDetalleAfecto)),'0.00000'))		Exonerada,
					Sum(iif(CE.ID <> 3,(iif(C.TotalDetalleInafecto is Null, '0.00000', C.TotalDetalleInafecto)),'0.00000'))		Inafecta,
					Sum(iif(CE.ID <> 3,(iif(C.TotalDetalleISC is Null, '0.00000', C.TotalDetalleISC)),'0.00000'))			ISC,
					Sum(iif(CE.ID <> 3,(iif(M.CodigoSunat = 'PEN',CD.PrecioIGV,CD.PrecioIGV*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1)),'0.00000'))			IGV,
					'0.00000'							OtrosTributos,
					Sum(iif(CE.ID <> 3,(iif(M.CodigoSunat = 'PEN',CD.PrecioTotal,CD.PrecioTotal*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1)),'0.00000'))		Total,
					C.TipoCambio				TipoCambio,
					Rf.Fecha					Fecha,
					Rf.CodigoSunat				TipoReferencia,
					Rf.Serie					SerieReferencia,
					Rf.Documento				ComprobantePagoReferencia
			FROM ERP.Comprobante C
			INNER JOIN ERP.ComprobanteDetalle CD
				ON C.ID = CD.IdComprobante
			INNER JOIN ERP.Empresa E
				ON C.IdEmpresa = E.ID
			LEFT JOIN PLE.T10TipoComprobante T10
				ON C.IdTipoComprobante = T10.ID
			LEFT JOIN ERP.Cliente Cl
				ON C.IdCliente = Cl.ID
			LEFT JOIN ERP.Entidad EN
				ON CL.IdEntidad = EN.ID
			LEFT JOIN ERP.EntidadTipoDocumento ETD
				ON EN.ID = ETD.IdEntidad
			LEFT JOIN PLE.T2TipoDocumento T2
				ON ETD.IdTipoDocumento = T2.ID
			LEFT JOIN ERP.Proyecto Py
				ON C.IdProyecto = Py.ID
			LEFT JOIN ERP.Vendedor V
				ON C.IdVendedor = V.ID
			LEFT JOIN ERP.Almacen A
				ON C.IdAlmacen = A.ID
			LEFT JOIN ERP.Trabajador T
				ON C.IdUsuario = T.ID
			LEFT JOIN Maestro.Moneda M
				ON C.IdMoneda = M.ID
			LEFT JOIN ERP.ListaPrecio L
				ON C.IdListaPrecio = L.ID
			LEFT JOIN Maestro.ComprobanteEstado CE
				ON C.IdComprobanteEstado = CE.ID
			LEFT JOIN ERP.Producto P
				ON CD.IdProducto = P.ID
			LEFT JOIN ERP.PlanCuenta PC
				ON P.IdPlanCuenta = PC.ID
			LEFT JOIN 
				(SELECT 
					CM.ID, C.Fecha, T10.CodigoSunat, C.Serie, C.Documento, T.VentaSunat from ERP.ComprobanteReferenciaInterno R
					INNER JOIN erp.Comprobante C
						ON R.IdComprobanteReferencia = C.ID
					INNER JOIN erp.TipoCambioDiario T
						ON C.Fecha = T.Fecha
					INNER JOIN ERP.Comprobante CM
						ON CM.ID = R.IdComprobante
					LEFT JOIN PLE.T10TipoComprobante T10
						ON C.IdTipoComprobante = T10.ID) RF
				ON C.ID = RF.ID
				WHERE C.IdEmpresa = @IdEmpresa AND MONTH(C.Fecha) = @Mes AND YEAR(C.FECHA) = @Anio AND C.FlagBorrador = 0
				GROUP BY C.Fecha, T10.CodigoSunat, T2.Abreviatura, C.PorcentajeIGV, C.IdTipoComprobante, C.Serie, C.Documento, ETD.NumeroDocumento, EN.Nombre,
				C.TotalDetalleExportacion, C.TotalDetalleAfecto, C.TotalDetalleInafecto, C.TotalDetalleISC, M.Simbolo,
				C.SubTotal, C.IGV, C.Total, C.TipoCambio, RF.Fecha, Rf.CodigoSunat, Rf.Serie, Rf.Documento
		)
		,COUNT_REGISTROVENTA AS (
				SELECT	COUNT(FechaEmision) AS [TotalCount]
				FROM	RegistroVentas
			)

			SELECT				FechaEmision,
								FechaVencimiento,
								Tipo,
								Serie, 
								Numero,
								Documento,
								RUC, 
								RazonSocial, 
								ValorFacturadoExportacion,
								BaseImponible,
								Exonerada,
								Inafecta,
								ISC,
								IGV,
								OtrosTributos,
								Total,
								TipoCambio,
								Fecha,
								TipoReferencia,
								SerieReferencia,
								ComprobantePagoReferencia,
								TotalCount
				FROM RegistroVentas,COUNT_REGISTROVENTA
				WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage ;
END
