
CREATE PROC [ERP].[Usp_Validar_Comprobante_Documento] --1,2,'F004','2',44
@IdEmpresa INT,
@IdTipoComprobante INT,
@Serie VARCHAR(4),
@Documento VARCHAR(20),
@IdComprobante INT
AS
BEGIN

DECLARE @DocumentoActual INT = (SELECT CAST(Documento AS INT)
								FROM ERP.Comprobante
								WHERE ID = @IdComprobante AND FlagBorrador = 0)

DECLARE @DocumentoMayor INT = (SELECT MAX(CAST(Documento AS INT)) 
								FROM ERP.Comprobante
								WHERE IdEmpresa = @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante AND 
								Serie = @Serie AND ID != @IdComprobante AND FlagBorrador = 0)

DECLARE @ExistDocumento INT = (SELECT COUNT(ID) 
								FROM ERP.Comprobante
								WHERE IdEmpresa = @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante AND 
								Serie = @Serie AND Documento = @Documento AND ID != @IdComprobante AND FlagBorrador = 0)
 
IF @DocumentoActual =  @Documento AND  @Documento != 0
BEGIN
	SELECT(0)
END
ELSE IF @ExistDocumento > 0 --El documento existe
BEGIN
	SELECT(1)
END
ELSE IF (CAST(@Documento AS INT) < @DocumentoMayor OR (CAST(@Documento AS INT) != @DocumentoMayor + 1)) AND CAST(@Documento AS INT) != 0 -- el documento no es correlativo
BEGIN
	SELECT(2)
END
ELSE 
BEGIN
	SELECT(0)
END

END
