
CREATE PROC [ERP].[Usp_Upd_Entidad_Borrador]
@IdEntidad				INT,
@IdTipoPersona			INT,
@IdTipoDocumento		INT,
@NumeroDocumento		VARCHAR(20),
@NombreCompleto			VARCHAR(50),
@RazonSocial			VARCHAR(250),
@Nombre					VARCHAR(50),
@ApellidoPaterno		VARCHAR(50),
@ApellidoMaterno		VARCHAR(50),
@IdSexo					INT,
@IdCondicionSunat		INT,
@EstadoSunat			BIT,
@IdTipoEstablecimiento	INT,
@NombreEstablecimiento	VARCHAR(50),
@IdVia					INT,
@NombreVia				VARCHAR(50),
@NumeroVia				VARCHAR(4),
@Interior				VARCHAR(4),
@IdZona					INT,
@NombreZona				VARCHAR(50),
@Referencia				VARCHAR(50),
@Direccion				VARCHAR(250),
@IdUbigeo				INT
AS

BEGIN
BEGIN TRAN
	BEGIN TRY
		
		DECLARE @IdTipoPersonaEntidad INT = (SELECT IdTipoPersona FROM ERP.Entidad E WHERE E.ID = @IdEntidad);

		IF(@IdTipoPersonaEntidad = 1 AND  @IdTipoPersona = 2) --== Si se realiza cambio de P.Natural a Juridica
		BEGIN
			DELETE FROM ERP.Persona WHERE IdEntidad = @IdEntidad --== Se elimina el registro de la tabla Persona
		END

		IF (@IdTipoPersona = 1 AND @IdTipoPersonaEntidad = 2) --== Si se realiza cambio de P.Juridica a Natural
		BEGIN

			EXEC [ERP].[Usp_Ins_Persona] @IdEntidad,@ApellidoMaterno,@ApellidoPaterno,@Nombre,@IdSexo --==Se registra en la tabla Persona
		END

		IF(@IdTipoPersona = 1 AND @IdTipoPersonaEntidad = 1) ---== Si es P.Natural se modifica
		BEGIN
			EXEC [ERP].[Usp_Upd_Persona] @IdEntidad, @ApellidoPaterno, @ApellidoMaterno,@Nombre,@IdSexo
		END

		---=== UPDATE ENTIDAD ===---

		UPDATE ERP.Entidad SET	Nombre = @NombreCompleto, 
								IdTipoPersona = @IdTipoPersona
		WHERE ID = @IdEntidad

		---=== UPDATE ENTIDAD TIPO DOCUMENTO ===---

		UPDATE ERP.EntidadTipoDocumento SET IdTipoDocumento = @IdTipoDocumento,
											NumeroDocumento = @NumeroDocumento
		WHERE IdEntidad = @IdEntidad

		--== UPDATE ESTABLECIMIENTO ===---
		
		EXEC ERP.Usp_Upd_Establecimiento @IdEntidad,@IdTipoEstablecimiento,@IdVia,@IdZona,@IdUbigeo,@NombreEstablecimiento,@Direccion,@NombreVia,@NumeroVia,@Interior,@NombreZona,@Referencia,0,1 
	

	COMMIT TRAN
	END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
END