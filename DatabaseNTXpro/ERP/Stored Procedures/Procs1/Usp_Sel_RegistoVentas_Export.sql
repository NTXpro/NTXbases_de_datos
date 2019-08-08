CREATE PROCEDURE [ERP].[Usp_Sel_RegistoVentas_Export]  
@IdEmpresa int,
@Anio int,
@Mes int       
AS
BEGIN
SELECT          
					C.Fecha					FechaEmision,
					 C.Fecha					FechaVencimiento,
					 T10.CodigoSunat			Tipo,
					 C.Serie					Serie,					  
					 C.Documento				Numero,
					 T2.Abreviatura				Documento,
					 ETD.NumeroDocumento		RUC, 
					 EN.Nombre					RazonSocial, 
					 C.TotalDetalleExportacion	ValorFacturadoExportacion,
					Sum(iif(CE.ID <> 3,(iif(M.CodigoSunat = 'PEN',C.SubTotal,C.SubTotal*iif(T10.CodigoSunat='07',RF.VentaSunat,TC.VentaSunat))*iif(T10.CodigoSunat='07',-1,1)),'0.00000')) BaseImponible,
					C.TotalDetalleAfecto		Exonerada,
					C.TotalDetalleInafecto		Inafecta,
					C.TotalDetalleISC			ISC,
					Sum(iif(CE.ID <> 3,(iif(M.CodigoSunat = 'PEN',C.IGV,C.IGV*iif(T10.CodigoSunat='07',RF.VentaSunat,TC.VentaSunat))*iif(T10.CodigoSunat='07',-1,1)),'0.00000'))			IGV,
					''							OtrosTributos,
					Sum(iif(CE.ID <> 3,(iif(M.CodigoSunat = 'PEN',C.Total,C.Total*iif(T10.CodigoSunat='07',RF.VentaSunat,TC.VentaSunat))*iif(T10.CodigoSunat='07',-1,1)),'0.00000'))		Total,
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
			INNER JOIN ERP.TipoCambioDiario TC
				ON C.Fecha = TC.Fecha
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
END