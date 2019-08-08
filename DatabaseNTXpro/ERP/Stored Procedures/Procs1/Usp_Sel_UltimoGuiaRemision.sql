CREATE PROC ERP.Usp_Sel_UltimoGuiaRemision
@IdEmpresa INT,
@IdTipoComprobante INT,
@Serie VARCHAR(4)
AS
BEGIN
	SELECT ID,
		   Serie,
		   Documento,
		   IdGuiaRemisionEstado 
	FROM ERP.GuiaRemision 
	WHERE IdEmpresa =  @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante AND Serie = @Serie AND 
	Documento =  (SELECT MAX(Documento) FROM ERP.GuiaRemision WHERE IdEmpresa =  @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante AND Serie = @Serie AND FlagBorrador = 0)
END
