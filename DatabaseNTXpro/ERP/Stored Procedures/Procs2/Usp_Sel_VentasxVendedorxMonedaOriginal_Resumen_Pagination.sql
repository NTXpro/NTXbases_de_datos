CREATE PROC [ERP].[Usp_Sel_VentasxVendedorxMonedaOriginal_Resumen_Pagination] --1,'2017-01-01','2017-01-31',1,50,'RUC','DESC',5
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

		WITH VentasVendedorResumengOriginal AS
		(
			SELECT ROW_NUMBER() OVER
			(ORDER BY 

					--ASC
						CASE WHEN (@SortType = 'NombreVendedor' AND @SortDir = 'ASC') THEN VN.Nombre END ASC,
						CASE WHEN (@SortType = 'NombreCliente' AND @SortDir = 'ASC') THEN CL.Nombre END ASC,
						--CASE WHEN (@SortType = 'TotalPEN' AND @SortDir = 'ASC') THEN EN.Nombre END ASC,
						
						--DESC
						CASE WHEN (@SortType = 'Vendedor' AND @SortDir = 'DESC') THEN VN.Nombre END DESC,
						CASE WHEN (@SortType = 'UnidadMedida' AND @SortDir = 'DESC') THEN CL.Nombre END DESC
						--CASE WHEN (@SortType = 'TotalPEN' AND @SortDir = 'DESC') THEN EN.Nombre END DESC

			)
		AS ROWNUMBER,

						VN.Nombre					NombreVendedor,
						CL.Nombre					NombreCliente,
						sum (iif(M.CodigoSunat = 'PEN',CD.PrecioSubTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										SubTotalPEN,
						sum (iif(M.CodigoSunat = 'PEN',CD.PrecioIGV,'0.00000')*iif(T10.CodigoSunat='07',-1,1))											IGVPEN,
						sum (iif(M.CodigoSunat = 'PEN',CD.PrecioTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										TotalPEN,
						sum (iif(M.CodigoSunat = 'USD',CD.PrecioSubTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										SubTotalUSD,
						sum (iif(M.CodigoSunat = 'USD',CD.PrecioIGV,'0.00000')*iif(T10.CodigoSunat='07',-1,1))											IGVUSD,
						sum (iif(M.CodigoSunat = 'USD',CD.PrecioTotal,'0.00000')*iif(T10.CodigoSunat='07',-1,1))										TotalUSD,
						sum (iif(M.CodigoSunat = 'PEN',CD.PrecioSubTotal,CD.PrecioSubTotal*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))			SubTotalConvPen,
						sum (iif(M.CodigoSunat = 'PEN',CD.PrecioIGV,CD.PrecioIGV*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))					IGVConvPen,
						sum (iif(M.CodigoSunat = 'PEN',CD.PrecioTotal,CD.PrecioTotal*iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))				TotalConvPen,
						sum (iif(M.CodigoSunat = 'USD',CD.PrecioSubTotal,CD.PrecioSubTotal/iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))			SubTotalConvUSD,
						sum (iif(M.CodigoSunat = 'USD',CD.PrecioIGV,CD.PrecioIGV/iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))					IGVConvUSD,
						sum (iif(M.CodigoSunat = 'USD',CD.PrecioTotal,CD.PrecioTotal/iif(T10.CodigoSunat='07',C.TipoCambio,C.TipoCambio))*iif(T10.CodigoSunat='07',-1,1))				TotalConvUSD,
						'' Porcentaje					-- Total del documento convertido en soles / Total General * 100
					FROM ERP.Comprobante C
					INNER JOIN ERP.ComprobanteDetalle CD
						ON C.ID = CD.IdComprobante
					INNER JOIN ERP.Empresa E
						ON C.IdEmpresa = E.ID
					LEFT JOIN PLE.T10TipoComprobante T10
						ON C.IdTipoComprobante = T10.ID
					LEFT JOIN -- Para cojer no se xd
						(SELECT CL.ID, E.Nombre, CL.IdEntidad FROM ERP.Cliente CL
							INNER JOIN ERP.Entidad E
							ON CL.IdEntidad = E.ID
						) CL
						ON C.IdCliente = Cl.ID
					LEFT JOIN ERP.Entidad EN
						ON CL.IdEntidad = EN.ID
					LEFT JOIN ERP.EntidadTipoDocumento ETD
						ON EN.ID = ETD.IdEntidad
					LEFT JOIN PLE.T2TipoDocumento T2
						ON ETD.IdTipoDocumento = T2.ID
					LEFT JOIN ERP.Proyecto Py
						ON C.IdProyecto = Py.ID
					LEFT JOIN -- Para cojer el nombre del Vendedor
						(SELECT V.ID, E.Nombre FROM ERP.Vendedor V
							INNER JOIN ERP.Trabajador T
							ON V.IdTrabajador = T.ID
							INNER JOIN ERP.Entidad E
							ON E.ID = T.IdEntidad
						) VN
						ON C.IdVendedor = VN.ID
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
					LEFT JOIN PLE.T6UnidadMedida T6	-- Agrege para el Detalle
						ON P.IdUnidadMedida = T6.ID
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
						GROUP BY VN.Nombre,CL.Nombre

			)
			,COUNT_VENTASVENDEDOR_RESUMEN AS (
					SELECT COUNT(NombreVendedor) AS [TotalCount]
					FROM VentasVendedorResumengOriginal
				)
				SELECT			
				
								NombreVendedor,
								NombreCliente,
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
				FROM 	VentasVendedorResumengOriginal, COUNT_VENTASVENDEDOR_RESUMEN
				WHERE	ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage  -- todos los procedures
				ORDER BY NombreVendedor,NombreCliente
END
