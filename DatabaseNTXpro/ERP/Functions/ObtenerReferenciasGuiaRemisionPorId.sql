-- =============================================
-- Author:	<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION ERP.ObtenerReferenciasGuiaRemisionPorId
(
@Id int
)
RETURNS varchar(max)
AS
BEGIN
-- Declare the return variable here
DECLARE @retorno varchar(max)

--DECLARE @Tabla TABLE (Id int, Nombre varchar(100), Referencia varchar(max))
--DECLARE @Nombre  nvarchar(30)
--DECLARE @Referencia  nvarchar(30)
--DECLARE ProdInfo CURSOR FOR SELECT GR.ID, E.Nombre, CONCAT(T10.Abreviatura, '-', GRR.Documento) Referencia	FROM ERP.GuiaRemision GR
--INNER JOIN ERP.GuiaRemisionReferencia GRR ON GRR.IdGuiaRemision = GR.ID
--INNER JOIN PLE.T10TipoComprobante T10 ON T10.ID = GRR.IdTipoComprobante
--LEFT JOIN ERP.Pedido P ON P.ID = GRR.IdReferencia
--LEFT JOIN ERP.Establecimiento E ON E.ID = P.IdEstablecimientoCliente
--ORDER BY GR.ID
--OPEN ProdInfo
--FETCH NEXT FROM ProdInfo INTO @Id,@Nombre,@Referencia
--WHILE
-- @@fetch_status = 0
--BEGIN
--IF EXISTS( SELECT * FROM @Tabla t WHERE t.id = @Id)
--BEGIN
--UPDATE @Tabla
--SET
--Referencia = Referencia + ' ' + @Referencia
--WHERE  id = @Id
--END
--ELSE
--BEGIN
--INSERT @Tabla
--(
--Id,
--Nombre,
--Referencia
--)
--VALUES
--(
--@Id, -- Id - int
--@Nombre, -- Nombre - varchar
--@Referencia -- Referencia - varchar
--)
--END



--FETCH NEXT FROM ProdInfo INTO @Id,@Nombre,@Referencia
--END
--CLOSE ProdInfo
--DEALLOCATE ProdInfo


         --SET @retorno =( SELECT isnull(t.Nombre,'') + ' '+  isnull(t.Referencia,'') as Cadena FROM @Tabla t WHERE t.id =@Id)

SET @retorno = ''
RETURN @retorno

END