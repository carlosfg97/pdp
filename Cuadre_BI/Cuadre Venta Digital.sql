
--obtiene la venta (MN y DOL) por palanca digital para una determinada campaña.
--SEGUN la tabla resultado palancas que es la que alimenta el dashboard-PowerBI
SELECT ANIOCAMPANA, DesPalanca, SUM(RealVtaMNNeto) AS RealVtaMNNeto, SUM(RealVtaDolNeto) AS RealVtaDolNeto
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718')
GROUP BY ANIOCAMPANA, DesPalanca
ORDER BY AnioCampana, DesPalanca

--mismo query pero crea una columna de nro consultoras
SELECT ANIOCAMPANA, DesPalanca, COUNT(DISTINCT PKEBELISTA) AS NroConsultoras, SUM(RealVtaMNNeto) AS RealVtaMNNeto, SUM(RealVtaDolNeto) AS RealVtaDolNeto
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') AND DesPalanca <> 'PASO PEDIDO'
GROUP BY ANIOCAMPANA, DesPalanca
ORDER BY AnioCampana, DesPalanca

--obtiene la venta en MN por Descripción de Catálogo luego de buscar todas las ventas que tuvieron como TipoOferta algun codigo digital
-- Filtras solamente las ventas que tenían un TipoOferta perteneciente a las ofertas digitales.
SELECT A.AnioCampana,b.DesCatalogo, sum(a.RealVtaMNNeto) as Venta 
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
group by A.AnioCampana,b.DesCatalogo 


--mismo query pero crea una columna de nro consultoras
SELECT A.AnioCampana,b.DesCatalogo,  COUNT(DISTINCT PKEBELISTA) AS NroConsultoras,
 sum(a.RealVtaMNNeto) as Venta FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
 --and a.PkProducto = b.PkProducto and a.PkTipoOferta = b.PkTipoOferta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201717') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and CodTipo
group by A.AnioCampana,b.DesCatalogo 




--tabla de somosbelcorp "DOrigenPedidoWeb"

--OBTIENE la tabla de marcaciones en palancas según SB
SELECT A.AnioCampana, DesSeccion, count(distinct a.PKEbelista) as consultoras, SUM(a.RealVtaMNNeto) as RealVtaMNNeto
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
where a.AnioCampana = '201718' and A.AnioCampana = A.AnioCampanaRef  
group by A.AnioCampana, DesSeccion




---------------
select DesMedio, DesSeccion, sum(RealVtaMNNeto)
from DOrigenPedidoWeb A INNER join FVTAPROEBECAMC01 B ON A.OrigenPedidoWeb = B.CodigoPalanca 
inner join DTIPOOFERTA c ON b.PkTiPOoFERTA = c.pKTIpooferta
where AnioCampana = '201801' and b.AnioCampana = b.AnioCampanaRef AND CodTipooferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
group by DesMedio, DesSeccion

select CodTipoOferta, DesTipoOferta, sum(RealVtaMNNeto)
from FVTAPROEBECAMC01 a  INNER join DTIPOOFERTA b ON a.PkTiPOoFERTA = B.pKTIpooferta
where AnioCampana = '201801' and AnioCampana = AnioCampanaRef
and CodTipooferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
group by CodTipoOferta, DesTipoOferta
--where CodTipo


select distinct CodigoPalanca, count(1) from FVTAPROEBECAMC01 where AnioCampana = '201802' group by CodigoPalanca
--existe ofertas para ti y OPM al mismo tiempo

--mismo query pero crea una columna de nro consultoras
SELECT A.AnioCampana,b.DesCatalogo,  COUNT(DISTINCT PKEBELISTA) AS NroConsultoras,
 sum(a.RealVtaMNNeto) as Venta FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
 --and a.PkProducto = b.PkProducto and a.PkTipoOferta = b.PkTipoOferta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201717') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
group by A.AnioCampana,b.DesCatalogo 

select CodVenta, count(CodVenta)
from
DMATRIZCAMPANA WHERE AnioCampana = '201717'
GROUP BY CodVenta
order by count(CodVenta) desc

select * from Dorigenpedidoweb

select DesSeccion, sum(realvtamnneto) as Venta, count(DISTINCT PkEBELISTA) as Consultoras
from FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb b ON A.CodigoPalanca = b.OrigenPedidoWeb
inner join  DTIPOOFERTA c on A.PKTipoOferta = c.PKTipoOferta
where AnioCampana = '201802' and CodTipoOferta in ('228','226','217','216','214','213','211','210','209','207','206','204','203','202')
group by DesSeccion

select * from DMATRIZCAMPANA where AnioCampana = '201805'




