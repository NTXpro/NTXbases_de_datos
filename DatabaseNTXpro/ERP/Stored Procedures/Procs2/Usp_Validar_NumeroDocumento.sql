CREATE PROC [ERP].[Usp_Validar_NumeroDocumento]
@IdEntidad INT,
@IdTipoDocumento INT,
@NumeroDocumento VARCHAR(20)
AS
BEGIN
	
	DECLARE @RESULT INT = (SELECT COUNT(ETD.ID) 
							FROM ERP.EntidadTipoDocumento ETD 
							INNER JOIN ERP.Entidad E
								ON ETD.IdEntidad = E.ID
						   WHERE IdTipoDocumento = @IdTipoDocumento AND NumeroDocumento = @NumeroDocumento
						   AND E.ID != @IdEntidad AND E.FlagBorrador = 0)

	SELECT @RESULT
END