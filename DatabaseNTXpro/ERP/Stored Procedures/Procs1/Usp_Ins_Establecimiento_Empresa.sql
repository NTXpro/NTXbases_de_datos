
CREATE PROCEDURE [ERP].[Usp_Ins_Establecimiento_Empresa]
@IdEntidad				INT,
@IdTipoEstablecimiento	INT,
@IdVia					INT,
@IdZona					INT,
@IdUbigeo				INT,
@NombreEstablecimiento	VARCHAR(250),
@Direccion				VARCHAR(250),
@NombreVia				VARCHAR(250),
@NumeroVia				VARCHAR(4),
@Interior				VARCHAR(4),
@NombreZona				VARCHAR(50),
@Sector					VARCHAR(50),
@Grupo					VARCHAR(50),
@Manzana				VARCHAR(50),
@Lote					VARCHAR(50),
@Kilometro				VARCHAR(50),
@Telefono				VARCHAR(50),
@Celular				VARCHAR(50),
@Referencia				VARCHAR(250),
@IdPais					INT,
@FlagBorrador			BIT,
@Flag					BIT,
@UsuarioRegistro		VARCHAR(250),
@FechaRegistro			DATETIME
AS
BEGIN

	INSERT INTO ERP.Establecimiento(IdEntidad,IdTipoEstablecimiento,IdVia,IdZona,IdUbigeo,Nombre,Direccion,ViaNombre,ViaNumero,Interior,ZonaNombre,Referencia,Telefono,Celular,FlagBorrador,Flag, UsuarioRegistro, FechaRegistro)
	VALUES(@IdEntidad,@IdTipoEstablecimiento,@IdVia,@IdZona,@IdUbigeo,@NombreEstablecimiento,@Direccion,@NombreVia,@NumeroVia,@Interior,@NombreZona,@Referencia,@Telefono,@Celular,@FlagBorrador,@Flag, @UsuarioRegistro, @FechaRegistro)

	DECLARE @IdEstablecimiento INT = (SELECT CAST(SCOPE_IDENTITY() AS int));

	SELECT @IdEstablecimiento
END
