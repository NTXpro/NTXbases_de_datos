
CREATE PROC [ERP].[Usp_Validar_GuiaRemision_Documento] --1,2,'F004','2',44
@IdEmpresa INT,
@Documento VARCHAR(20),
@Serie VARCHAR(4),
@IdGuiaRemision INT
AS
BEGIN

DECLARE @DocumentoActual INT = (SELECT CAST(Documento AS INT)
								FROM ERP.GuiaRemision
								WHERE ID = @IdGuiaRemision AND FlagBorrador = 0)

DECLARE @DocumentoMayor INT = (SELECT MAX(CAST(Documento AS INT)) 
								FROM ERP.GuiaRemision
								WHERE IdEmpresa = @IdEmpresa AND 
								Serie = @Serie AND ID != @IdGuiaRemision AND FlagBorrador = 0)

DECLARE @ExistDocumento INT = (SELECT COUNT(ID) 
								FROM ERP.GuiaRemision
								WHERE IdEmpresa = @IdEmpresa AND 
								Serie = @Serie AND Documento = @Documento AND ID != @IdGuiaRemision AND FlagBorrador = 0)
 
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