
CREATE PROC [ERP].[Usp_Upd_Persona]
@IdEntidad			INT,
@ApellidoPaterno	VARCHAR(50),
@ApellidoMaterno	VARCHAR(50),
@Nombre				VARCHAR(250),
@IdSexo				INT,
@IdPais				INT,
@IdEstadoCivil		INT,
@IdCentroAsistencial INT,
@FechaNacimiento	DATETIME
AS
BEGIN

	IF(@IdCentroAsistencial IS NULL)
		BEGIN
		 SET @IdCentroAsistencial = 1 ;
		END

	UPDATE ERP.Persona SET Nombre = @Nombre, ApellidoPaterno = @ApellidoPaterno, ApellidoMaterno = @ApellidoMaterno, IdSexo = @IdSexo , 
						IdPais=@IdPais , IdEstadoCivil=@IdEstadoCivil,IdCentroAsistencial=@IdCentroAsistencial , FechaNacimiento = @FechaNacimiento
	WHERE IdEntidad = @IdEntidad

END
