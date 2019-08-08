CREATE PROC SEL_SOCIOFEBRERO
AS
SELECT E.NOMBRE,CD.NOMBRE,C.Observacion,cast(isnull (C.TOTAL,0) AS DECIMAL(18,2)) AS TOTAL  FROM ERP.COMPROBANTE C
              INNER JOIN ERP.ComprobanteDetalle CD
			  ON C.ID = CD.IDCOMPROBANTE
			  INNER JOIN ERP.Cliente CL
			  	 ON CL.ID=C.IdCliente
		       INNER JOIN ERP.Entidad E
		     ON CL.IdEntidad=E.ID
		      INNER JOIN ERP.EntidadTipoDocumento ETP
		       ON E.ID=ETP.IdEntidad
			  WHERE MONTH(C.FECHAREGISTRO)=02
			    AND C.FlagBorrador =0 
			   AND C.IdTipoComprobante = 202  
			  AND C.Documento Is Not NULL
			   AND NOT C.IdComprobanteEstado = 3 
			   AND CD.NOMBRE LIKE '%ENERO%'
			   AND NOT CD.NOMBRE LIKE '%CASILLERO%'
			   UNION
			 SELECT E.NOMBRE,CD.NOMBRE,C.Observacion,cast(isnull (C.TOTAL,0) AS DECIMAL(18,2)) AS TOTAL  FROM ERP.COMPROBANTE C
              INNER JOIN ERP.ComprobanteDetalle CD
			  ON C.ID = CD.IDCOMPROBANTE
			  INNER JOIN ERP.Cliente CL
			  	 ON CL.ID=C.IdCliente
		       INNER JOIN ERP.Entidad E
		     ON CL.IdEntidad=E.ID
		      INNER JOIN ERP.EntidadTipoDocumento ETP
		       ON E.ID=ETP.IdEntidad
			  WHERE MONTH(C.FECHAREGISTRO)=02
			    AND C.FlagBorrador =0 
			   AND C.IdTipoComprobante = 202  
			  AND C.Documento Is Not NULL
			   AND NOT C.IdComprobanteEstado = 3 
			   AND C.Observacion LIKE '%ENERO%'