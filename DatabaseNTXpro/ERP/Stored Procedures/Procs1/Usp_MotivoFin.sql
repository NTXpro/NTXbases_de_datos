
-- Stored Procedure

-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 27/03/2019
-- Description:	LISTADO DE
-- =============================================
CREATE PROCEDURE [ERP].[Usp_MotivoFin]
as	
BEGIN
	SELECT tf.ID, tf.Nombre, tf.CodigoSunat FROM PLAME.T17MotivoFin tf
END