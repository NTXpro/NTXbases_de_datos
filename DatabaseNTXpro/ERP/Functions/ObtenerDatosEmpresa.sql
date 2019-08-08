
CREATE FUNCTION [ERP].[ObtenerDatosEmpresa](@IdEmpresa INT)
RETURNS VARCHAR(250)
AS
BEGIN
		DECLARE @DatosEmpresa VARCHAR(250) = '';
		DECLARE @Correo VARCHAR(250) = (SELECT Correo FROM ERP.Empresa WHERE ID = @IdEmpresa);
		DECLARE @Web VARCHAR(250) = (SELECT Web FROM ERP.Empresa WHERE ID = @IdEmpresa);
		DECLARE @Telefono VARCHAR(50) = (SELECT Telefono FROM ERP.Empresa WHERE ID = @IdEmpresa);
		DECLARE @Celular VARCHAR(50) = (SELECT Celular FROM ERP.Empresa WHERE ID = @IdEmpresa);
		
		IF @Web IS NOT NULL AND @Web != ''
		BEGIN
			SET @DatosEmpresa += 'Web: '+ @Web+'      ';
		END

		IF @Correo IS NOT NULL AND @Correo != ''
		BEGIN
			SET @DatosEmpresa += 'Correo: '+ @Correo+'      ';
		END	

		IF @Telefono IS NOT NULL AND @Telefono != ''
		BEGIN
			SET @DatosEmpresa += 'Teléfono: '+ @Telefono+'      ';
		END	

		IF @Celular IS NOT NULL AND @Celular != ''
		BEGIN
			SET @DatosEmpresa += 'Celular: '+ @Celular+'      ';
		END	

		RETURN @DATOSEMPRESA
END
