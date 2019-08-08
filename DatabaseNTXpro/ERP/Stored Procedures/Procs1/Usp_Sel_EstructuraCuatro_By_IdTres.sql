
CREATE PROCEDURE [ERP].[Usp_Sel_EstructuraCuatro_By_IdTres]
@IdEstructuraTres INT
AS
BEGIN
	SELECT
       EBGC.ID
	  ,EBGC.IdEstructuraTres
	  --,EBGC.IdPlanCuenta
	  ,EBGC.CuentaContable
	  ,EBGC.Operador
	  ,EBGC.Orden
	  ,EBGT.Nombre AS NombreTres
	FROM [ERP].[EstructuraCuatro] EBGC
	INNER JOIN [ERP].[EstructuraTres] EBGT ON EBGC.IdEstructuraTres = EBGT.ID
	WHERE EBGC.IdEstructuraTres = @IdEstructuraTres AND
	EBGC.Flag = 1
	ORDER BY EBGC.CuentaContable ASC
END
