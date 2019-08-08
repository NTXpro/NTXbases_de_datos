CREATE PROC [ERP].[Usp_Del_Salud]
@IdSalud INT,
@IdDatoLaboral INT
AS
BEGIN
	DECLARE @ID_DATO_LABORAL INT = (SELECT TOP 1 IdDatoLaboral FROM ERP.DatoLaboralSalud WHERE ID = @IdSalud);
	DECLARE @ID_EMPRESA INT = (SELECT TOP 1 IdEmpresa FROM ERP.DatoLaboralSalud WHERE ID = @IdSalud);
	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.DatoLaboralSalud
							WHERE IdEmpresa = @ID_EMPRESA AND IdDatoLaboral = @ID_DATO_LABORAL AND ID != @IdSalud
							ORDER BY ID DESC );

	DELETE FROM ERP.DatoLaboralSalud WHERE ID = @IdSalud

	UPDATE ERP.DatoLaboralSalud SET
	FechaFin = NULL
	WHERE ID = @LAST_ID;
END
