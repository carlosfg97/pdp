--OPT: Dashboard vs TO
drop table #PKDash
SELECT distinct PkEbelista into #PKDash
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') and DesPalanca = 'Ofertas Para tí'

drop table #PKTO
SELECT distinct PKEbelista into #PKTO
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and DesCatalogo = '45 - WEB OFERTAS PARA TI'

-- PkEbelistas contabilizadas en Datamart pero no en Dashboard
drop table #NoEnDashOPT
select * into #NoEnDashOPT
from #PKTO
where PKEbelista NOT IN (select PKEbelista from #PKDash)

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
drop table #PkSB
SELECT distinct A.PkEbelista into #PkSB
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef  and DesSeccion = 'Ofertas para ti'

drop table #NoEnSB
select * into #NoEnSB
from #PKTO
where PKEbelista NOT IN (select PKEbelista from #PkSB)	

-- la tabla de las ebelistas que aparecen en TO pero no en SB
SELECT a.PkEbelista, a.CodVenta, *
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

--SR: TO vs SB
drop table #PkSBSR
SELECT distinct A.PkEbelista into #PkSBSR
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef  
and DesSeccion in  ('ShowRoom', 'Home','Landing Compra', 'Landing Intriga','Product Page')
--(9423 row(s) affected)

select * from DOrigenPedidoWeb
where DesSeccion = 'ShowRoom'

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

--OF: Dashboard vs SomosBelcorp
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

SELECT * FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')
and b.DesCatalogo = 'FOLLETO/FLYER A NIVEL NACIONAL'
