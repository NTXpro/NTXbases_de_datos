CREATE PROC [ERP].[Usp_Sel_VentasxClientexMonedaOriginal_Ranking_Pagination] --1,'2017-01-01','2017-01-31',1,1000,'','',5
@IdEmpresa INT ,
@FechaInicio DATETIME,
@FechaFin DATETIME,
@Page INT,
@RowsPerPage INT,
@SortDir VARCHAR(20),
@SortType VARCHAR(30),
@RowCount INT OUT
AS 
BEGIN

		WITH VentasClienteRankingOriginal AS
		(
			SELECT ROW_NUMBER() OVER
			(ORDER BY 

					--ASC
						CASE WHEN (@SortType = 'RUC' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
						CASE WHEN (@SortType = 'RazonSocial' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
						CASE WHEN (@SortType = 'TotalConvPen' AND @SortDir = 'ASC') THEN 'TotalConvPen' END ASC,
						--CASE WHEN (@SortType = 'RUC' AND @SortDir = 'ASC') THEN ETD.NumeroDocumento END ASC,
						--CASE WHEN (@SortType = 'TotalPEN' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
						
						--DESC
						CASE WHEN (@SortType = 'RUC' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC,
						CASE WHEN (@SortType = 'RazonSocial' AND @SortDir = 'DESC') THEN EN.Nombre END DESC,
						CASE WHEN (@SortType = 'TotalConvPen' AND @SortDir = 'DESC') THEN 'TotalConvPen' END DESC
						--CASE WHEN (@SortType = 'RUC' AND @SortDir = 'DESC') THEN ETD.NumeroDocumento END DESC
						--CASE WHEN (@SortType = 'TotalPEN' AND @SortDir = 'DESC') THEN EN.Nombre END DESC

			)
		AS ROWNUMBER,

						ETD.NumeroDocumento			RUC, 
						EN.Nombre					RazonSocial,
						sum(iif(M.CodigoSunat = 'PEN',CD.PrecioSubTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))									SubTotalPEN,
						sum(iif(M.CodigoSunat = 'PEN',CD.PrecioIGV,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										IGVPEN,
						sum(iif(M.CodigoSunat = 'PEN',CD.PrecioTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										TotalPEN,
						sum(iif(M.CodigoSunat = 'USD',CD.PrecioSubTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))									SubTotalUSD,
						sum(iif(M.CodigoSunat = 'USD',CD.PrecioIGV,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										IGVUSD,
						sum(iif(M.CodigoSunat = 'USD',CD.PrecioTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										TotalUSD,
						sum(iif(M.CodigoSunat = 'PEN',CD.PrecioSubTotal,CD.PrecioSubTotal*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))			SubTotalConvPen,
						sum(iif(M.CodigoSunat = 'PEN',CD.PrecioIGV,CD.PrecioIGV*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))					IGVConvPen,
						sum(iif(M.CodigoSunat = 'PEN',CD.PrecioTotal,CD.PrecioTotal*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))				TotalConvPen,
						sum(iif(M.CodigoSunat = 'USD',CD.PrecioSubTotal,CD.PrecioSubTotal/iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))			SubTotalConvUSD,
						sum(iif(M.CodigoSunat = 'USD',CD.PrecioIGV,CD.PrecioIGV/iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))					IGVConvUSD,
						sum(iif(M.CodigoSunat = 'USD',CD.PrecioTotal,CD.PrecioTotal/iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))				TotalConvUSD,
						''							Porcentaje     -- Total del documento convertido en soles / Total General * 100
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
						(SELECT CM.ID, C.Fecha, T10.CodigoSunat, C.Serie, C.Documento, T.VentaSunat FROM ERP.ComprobanteReferenciaInterno R
							INNER JOIN ERP.Comprobante C
								ON R.IdComprobanteReferencia = C.ID
							INNER JOIN ERP.TipoCambioDiario T
								ON C.Fecha = T.Fecha
							INNER JOIN ERP.Comprobante CM
								ON CM.ID = R.IdComprobante
							LEFT JOIN PLE.T10TipoComprobante T10
								ON C.IdTipoComprobante = T10.ID) RF
						ON C.ID = RF.ID
						WHERE C.IdComprobanteEstado <> 3 and C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa AND C.Fecha BETWEEN @FechaInicio AND @FechaFin
						GROUP BY ETD.NumeroDocumento, EN.Nombre
					
							
			)
			,COUNT_VENTASCLIENTE_RANKING AS (
					SELECT COUNT(RUC) AS [TotalCount]
					FROM VentasClienteRankingOriginal

				)
				SELECT			RUC,
								RazonSocial,
								SubTotalPEN,
								IGVPEN,
								TotalPEN,
								SubTotalUSD,
								IGVUSD,
								TotalUSD,
								SubTotalConvPen,
								IGVConvPen,
								TotalConvPen,
								SubTotalConvUSD,
								IGVConvUSD,
								TotalConvUSD,
								Porcentaje,
								TotalCount
				FROM 	VentasClienteRankingOriginal, COUNT_VENTASCLIENTE_RANKING
				WHERE	ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
				ORDER BY TotalConvPen DESC
END
