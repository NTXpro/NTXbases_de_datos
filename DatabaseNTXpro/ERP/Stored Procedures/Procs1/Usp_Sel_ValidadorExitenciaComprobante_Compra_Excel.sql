CREATE PROC ERP.Usp_Sel_ValidadorExitenciaComprobante_Compra_Excel
 @IdTipoDocumento INT ,
 @NumeroDocumento VARCHAR(MAX),
 @IdTipoComprobante INT ,
 @Serie VARCHAR(MAX),
 @numero VARCHAR(MAX)
AS 
DECLARE @Resultado BIT = (select @@ROWCOUNT 
									FROM ERP.COMPRA C
									INNER JOIN ERP.Cliente c2
									ON c2.id = c.IdProveedor
									INNER JOIN ERP.Entidad e
									ON e.Id= c2.IdEntidad 
									INNER JOIN ERP.EntidadTipoDocumento etd
									ON etd.IdEntidad=e.id		
									WHERE
									etd.IdTipoDocumento =@IdTipoDocumento
									and etd.NumeroDocumento =@NumeroDocumento
									and c.IdTipoComprobante =@IdTipoComprobante
									and c.Serie =@Serie
									and c.numero =@numero)
Select IsNull(@Resultado, 0) As Resultado