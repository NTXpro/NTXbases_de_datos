
CREATE PROC [ERP].[Usp_Ins_EntidadTipoDocumento]
@IdEntidad			INT OUT,
@IdTipoPersona		INT,
@IdTipoDocumento	INT,
@IdCondicionSunat	INT,
@Nombre				VARCHAR(250),
@NumeroDocumento	VARCHAR(20),
@FlagBorrador		BIT,
@EstadoSunat		BIT
AS
BEGIN

	INSERT INTO ERP.Entidad(Nombre,IdTipoPersona,EstadoSunat,IdCondicionSunat,FlagBorrador,Flag) 
		VALUES(@Nombre,@IdTipoPersona,@EstadoSunat,@IdCondicionSunat,@FlagBorrador,1)

	SET @IdEntidad = (SELECT CAST(SCOPE_IDENTITY() AS INT));

	INSERT INTO ERP.EntidadTipoDocumento(IdEntidad,IdTipoDocumento,NumeroDocumento) 
	VALUES (@IdEntidad , @IdTipoDocumento, @NumeroDocumento);

END