--////////---------ODD----------\\\\\\\\
--ODD: Dashboard vs TO
drop table #PKDashODD
SELECT distinct PkEbelista into #PKDashODD
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') and DesPalanca = 'Ofertas del Día'

drop table #PKTOODD
SELECT distinct PKEbelista into #PKTOODD
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '46 - WEB OFERTAS DEL DÍA'

-- PkEbelistas contabilizadas en Datamart pero no en Dashboard
drop table #NoEnDashODD
select * into #NoEnDashODD
from #PKTOODD
where PKEbelista NOT IN (select PKEbelista from #PKDashODD)

-- muestra las ebelistas que estan siendo contadas por Datamart TO pero no por el dashboard
SELECT CodEbelista, a.CodVenta, *
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '46 - WEB OFERTAS DEL DÍA'
and a.PkEbelista in (select PkEbelista from #NoEnDashODD)


select  *
from DNROFACTURA
WHERE PkEbelista in (select PKEbelista from  #NoEnDashODD) and AnioCampana = '201718'
order by FechaEmisionFactura desc
--podria ser su fechaemisionfactura

select  *
from DNROFACTURA
WHERE PkEbelista not in (select PKEbelista from  #NoEnDashODD) and AnioCampana = '201718'
order by FechaEmisionFactura desc

--ODD: TO vs SB

--OPT: TO vs SB
drop table #PkSBODD
SELECT distinct A.PkEbelista into #PkSBODD
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef  and DesSeccion =  'Oferta del Día' 


drop table #NoEnSBODD
select * into #NoEnSBODD
from #PKTOODD
where PKEbelista NOT IN (select PKEbelista from #PkSBODD)	

-- la tabla de las ebelistas que aparecen en TO pero no en SB
SELECT a.PkEbelista, e.CodEbelista, a.CodVenta, *
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo ='46 - WEB OFERTAS DEL DÍA'
and a.PkEbelista in (select PkEbelista from #NoEnSBODD)



--para encontrar problemas de digitación
select CodEbelista, CodVenta, *
from DATAMARTANALITICO.dbo.arp_ofertapersonalizadac01 
WHERE CodPais = 'CO' and AnioCampanaVenta = '201718' and TipoPersonalizacion = 'SR'
and CodEbelista = '0232947'
and CodVenta ='95617'


--/////////////////---------OPT-----------\\\\\\\\\\\\\\
--OPT: Dashboard vs TO
drop table #PKDashOPT
SELECT distinct PkEbelista into #PKDashOPT
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') and DesPalanca = 'Ofertas Para tí'

drop table #PKTOOPT
SELECT distinct PKEbelista into #PKTOOPT
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '45 - WEB OFERTAS PARA TI'

-- PkEbelistas contabilizadas en Datamart pero no en Dashboard
drop table #NoEnDashOPT
select * into #NoEnDashOPT
from #PKTOOPT
where PKEbelista NOT IN (select PKEbelista from #PKDashOPT)

-- muestra las ebelistas que estan siendo contadas por Datamart TO pero no por el dashboard
SELECT CodEbelista, a.CodVenta, *
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '45 - WEB OFERTAS PARA TI'
and a.PkEbelista in (select PkEbelista from #NoEnDashOPT)

select  *
from DNROFACTURA
WHERE PkEbelista in (select PKEbelista from  #NoEnDashOPT) and AnioCampana = '201718'
order by FechaEmisionFactura desc

--OPT: TO vs SB
drop table #PkSBOPT
SELECT distinct A.PkEbelista into #PkSBOPT
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef  and DesSeccion = 'Ofertas para ti'

drop table #NoEnSBOPT
select * into #NoEnSBOPT
from #PKTO
where PKEbelista NOT IN (select PKEbelista from #PkSBOPT)	

-- la tabla de las ebelistas que aparecen en TO pero no en SB
SELECT a.PkEbelista, a.CodVenta, *
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '45 - WEB OFERTAS PARA TI'
and a.PkEbelista in (select PkEbelista from #NoEnSBOPT)


SELECT SUM(REALVTAMNNETO)
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '45 - WEB OFERTAS PARA TI'
and a.PkEbelista in (select PkEbelista from #NoEnSB)



------------------------------SHOWROOM (SR)-------------------------


drop table #PKDashSR
SELECT distinct PkEbelista into  #PKDashSR
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') and DesPalanca = 'Showroom'


drop table #PKTOSR
SELECT distinct PKEbelista into #PKTOSR
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '44 - WEB SHOWROOM'


DROP TABLE #NoEnDashSR
select * into #NoEnDashSR
from #PKTOSR
where PKEbelista NOT IN (select PKEbelista from #PKDashSR)

SELECT CodEbelista, a.CodVenta, *
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '44 - WEB SHOWROOM'
and a.PkEbelista in (select PkEbelista from #NoEnDashSR)

SELECT sum(REALVTAMNNETO)
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '44 - WEB SHOWROOM'
and a.PkEbelista in (select PkEbelista from #NoEnDashSR)

select distinct * from #NoEnDashSR

select codigofacturainternet, * from FSTAEBECAMC01
WHERE aniocampana = '201710' and PKEbelista in ( select PKEbelista from #NoEnDashSR)

--SR: TO vs SB
drop table #PkSBSR
SELECT distinct A.PkEbelista into #PkSBSR
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef  
and DesSeccion in ('ShowRoom', 'Home','Landing Compra', 'Landing Intriga','Product Page')

select distinct DesSeccion from DOrigenPedidoWeb
where DesZona = 'ShowRoom'

select * from DOrigenPedidoWeb
where DesZona = 'ShowRoom'


drop table #NoEnSBSR
select * into #NoEnSBSR
from #PKTOSR
where PKEbelista NOT IN (select PKEbelista from #PkSBSR)	




-- la tabla de las ebelistas que aparecen en TO pero no en SB
SELECT CodEbelista, a.CodVenta, *
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '44 - WEB SHOWROOM'
and a.PkEbelista in (select PkEbelista from #NoEnSBSR)

------------------- OFERTA FINAL (OF) ------ 


drop table #PKDashOF
SELECT distinct PkEbelista into  #PKDashOF
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') and DesPalanca = 'Oferta Final'
-- (1971 row(s) affected)


drop table #PkSBOF
SELECT distinct A.PkEbelista into #PkSBOF
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef  and DesSeccion = 'Oferta Final'
--(2006 row(s) affected)

drop table #NoEnDashOF
select * into  #NoEnDashOF
from #PkSBOF
where PKEbelista NOT IN (select PKEbelista from #PKDashOF)	

SELECT *
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef  and DesSeccion = ''
and a.PKEbelista in (select PkEbelista from #NoEnDashOF)

--(2006 row(s) affected)
