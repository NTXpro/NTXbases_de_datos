
	
	CREATE PROC [ERP].[Usp_Ins_MaestroDetraccion]
	@IdDetraccion INT OUT,
	@Nombre VARCHAR(50),
	@CodigoSunat VARCHAR(3),
	@Porcentaje DECIMAL(14,5),
	@UsuarioRegistro VARCHAR(250),
	@FlagBorrador  BIT
	AS
	BEGIN

		INSERT INTO Maestro.Detraccion (Nombre,CodigoSunat,Anexo,Orden,Porcentaje,UsuarioRegistro,FechaRegistro,FlagBorrador,Flag) VALUES (@Nombre,@CodigoSunat,4,1,@Porcentaje,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@FlagBorrador,1)

		SET @IdDetraccion = SCOPE_IDENTITY();

	END