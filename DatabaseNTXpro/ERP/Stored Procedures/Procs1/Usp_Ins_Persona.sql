
CREATE PROC [ERP].[Usp_Ins_Persona]
@IdEntidad			INT,
@ApellidoPaterno	VARCHAR(50),
@ApellidoMaterno	VARCHAR(50),
@Nombre				VARCHAR(50),
@IdSexo				INT ,
@IdPais				INT,
@IdEstadoCivil		INT,
@IdCentroAsistencial INT,
@FechaNacimiento	DATETIME
AS
BEGIN
	DECLARE @IdPersona INT

	IF(@IdCentroAsistencial IS NULL)
		BEGIN
		 SET @IdCentroAsistencial = 1 ;
		END

	INSERT INTO ERP.Persona(IdSexo,IdEntidad,Nombre,ApellidoPaterno,ApellidoMaterno,IdPais,IdEstadoCivil,IdCentroAsistencial,FechaNacimiento) VALUES (@IdSexo,@IdEntidad,@Nombre,@ApellidoPaterno,@ApellidoMaterno,@IdPais,@IdEstadoCivil,@IdCentroAsistencial,@FechaNacimiento)

	SET @IdPersona = (SELECT CAST(SCOPE_IDENTITY() AS INT));

END
