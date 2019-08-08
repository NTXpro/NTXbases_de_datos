CREATE PROCEDURE [ERP].[Usp_Sel_Importacion_ValidarReferenciaInterna] --1,165,'0001','00000003'
@IdEmpresa INT,
@IdTipoComprobante INT,
@Serie VARCHAR(20),
@Documento VARCHAR(20)
AS
BEGIN
	DECLARE @ID_REFERENCIA_ORIGEN INT = (SELECT TOP 1 ID FROM Maestro.ReferenciaOrigen WHERE Codigo = 'LOGOC');
	SELECT
		TOP 1
		@ID_REFERENCIA_ORIGEN AS IdReferenciaOrigen,
		OD.ID AS IdReferencia,
		OD.IdTipoComprobante,
		OD.Serie,
		OD.Documento,
		UPPER(TC.Abreviatura) AS AbreviaturaTipoComprobante
	FROM
	ERP.OrdenCompra OD
	INNER JOIN Maestro.OrdenCompraEstado ODE ON OD.IdOrdenCompraEstado = ODE.ID
	INNER JOIN PLE.T10TipoComprobante TC ON OD.IdTipoComprobante = TC.ID
	WHERE
	ISNULL(OD.FlagBorrador, 0) = 0 AND
	OD.Flag = 1 AND
	OD.Serie = RTRIM(LTRIM(@Serie)) AND
	OD.Documento = RTRIM(LTRIM(@Documento)) AND
	OD.IdEmpresa = @IdEmpresa AND
	OD.IdTipoComprobante = @IdTipoComprobante AND
	ODE.Abreviatura = 'AP'
END
