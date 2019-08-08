CREATE PROC ERP.Usp_Ins_TipoDocumentoEntidad
@IdEntidad INT,
@IdTipoDocumento INT,
@NumeroDocumento VARCHAR(20)
AS
BEGIN

	INSERT INTO ERP.EntidadTipoDocumento(IdEntidad,IdTipoDocumento,NumeroDocumento) 
	VALUES (@IdEntidad , @IdTipoDocumento, @NumeroDocumento);

	SELECT CAST(SCOPE_IDENTITY() AS INT);
END