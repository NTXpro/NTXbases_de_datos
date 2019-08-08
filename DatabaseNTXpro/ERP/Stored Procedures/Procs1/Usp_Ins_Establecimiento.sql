CREATE PROCEDURE [ERP].[Usp_Ins_Establecimiento]
@IdEntidad				INT,
@IdTipoEstablecimiento	INT,
@IdVia					INT,
@IdZona					INT,
@IdPais					INT,
@IdUbigeo				INT,
@NombreEstablecimiento	VARCHAR(250),
@Direccion				VARCHAR(250),
@NombreVia				VARCHAR(250),
@NumeroVia				VARCHAR(4),
@Interior				VARCHAR(4),
@NombreZona				VARCHAR(250),
@Referencia				VARCHAR(250),
@Sector					VARCHAR(20),
@Grupo					VARCHAR(20),
@Manzana				VARCHAR(20),
@Lote					VARCHAR(20),
@Kilometro				VARCHAR(20),
@FlagBorrador			BIT,
@Flag					BIT
AS
BEGIN

	INSERT INTO ERP.Establecimiento(IdEntidad,IdTipoEstablecimiento,IdVia,IdZona,IdPais,IdUbigeo,Nombre,Direccion,ViaNombre,ViaNumero,Interior,ZonaNombre,Referencia,Sector,Grupo,Manzana,Lote,Kilometro,FlagBorrador,Flag)
	VALUES(@IdEntidad,@IdTipoEstablecimiento,@IdVia,@IdZona,@IdPais,@IdUbigeo,@NombreEstablecimiento,@Direccion,@NombreVia,@NumeroVia,@Interior,@NombreZona,@Referencia,@Sector,@Grupo,@Manzana,@Lote,@Kilometro,@FlagBorrador,@Flag)

	DECLARE @IdEstablecimiento INT = (SELECT CAST(SCOPE_IDENTITY() AS int));

	SELECT @IdEstablecimiento
END
