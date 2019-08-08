CREATE PROC [ERP].[Usp_Sel_Concepto_By_Clase_Tipo]
@IdEmpresa INT,
@IdClase INT,
@IdTipoConcepto INT
AS
BEGIN
	SELECT ID
      ,Nombre
	  ,Orden
  FROM ERP.Concepto
  WHERE  IdClase = @IdClase AND IdTipoConcepto = @IdTipoConcepto
END
