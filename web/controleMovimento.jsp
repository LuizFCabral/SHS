<%-- 
    Document   : controleMovimento
    Created on : 09/10/2021, 17:55:11
    Author     : Pedro
--%>

<%@page import="model.*"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="controller.VacinaJpaController"%>
<%@page import="controller.DAOJPA"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Vacina"%>
<%@page import="java.util.List"%>
<%@page import="controller.MovimentoVacinaJpaController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consulta de movimentos</title>
    </head>
    <body>
        <a href="index.jsp">Tela inicial</a>
<%
            request.setCharacterEncoding("UTF-8");
            MovimentoVacina obj;
            String b;
            MovimentoVacinaJpaController dao;
            VacinaJpaController daoV;
            DAOJPA daoJ;
            Banco bb;
            
            try 
            {
                bb = new Banco();
                dao = new MovimentoVacinaJpaController(Banco.conexao);
                daoV = new VacinaJpaController(Banco.conexao);
                SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
                SimpleDateFormat tF = new SimpleDateFormat("dd/MM/yyyy HH:mm"); //Formatador geral
                SimpleDateFormat hF = new SimpleDateFormat("HH:mm"); //Formatador de horas
                
                //código de mesma estrutura dos CRUDs, consultá-los caso haja necessidade de melhor entendimento do seu funcionamento.
                if(request.getParameter("b1") == null)
                {
                    if(request.getParameter("bCarregar") == null)
                    {
%>                      
                        <form action="controleMovimento.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod"/> <br/>
                            Código da vacina: <input type="text" name="txtCodVac"/> <br/>
                            Data do movimento: <input type="text" name="txtDataMov" readonly/> <br/>
                            Hora do movimento: <input type="text" name="txtHoraMov"/> <br/>
                            Tipo do movimento: <input type="text" name="txtTipo"/> <br/>
                            Quantidade: <input type="text" name="txtQuant"/><br/>
                            Lote: <input type="text" name="txtLote"/><br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                        </form>
<%
                    }
                    else
                    {
                        obj = dao.findMovimentoVacina(Integer.parseInt(request.getParameter("bCarregar")));
%>
                        <form action="controleMovimento.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod" value="<%=obj.getCodigo()%>"/> <br/>
                            Código da vacina: <input type="text" name="txtCodVac" value="<%=obj.getCodigoVacina().getCodigo()%>"/> <br/>
                            Data do movimento: <input type="text" name="txtDataMov" value="<%=dF.format(obj.getDataMovimento())%>"/> <br/>
                            Hora do movimento: <input type="text" name="txtHoraMov" value="<%=hF.format(obj.getDataMovimento())%>"/> <br/>
                            Tipo do movimento: <input type="text" name="txtTipo" value="<%=obj.getTipoMovimento()%>"/> <br/>
                            Quantidade: <input type="text" name="txtQuant" value="<%=obj.getQtdeDose()%>"/><br/>
                            Lote: <input type="text" name="txtLote" value="<%=obj.getCodigoLote().getDescricao()%>"/><br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                        </form>
<%
                    }
                }
                else
                {
                    b = request.getParameter("b1");
                    int cod;
                    switch(b)
                    {
                        case "Cadastrar":
                            obj = new MovimentoVacina();
                            obj.setCodigoVacina(daoV.findVacina(Integer.parseInt(request.getParameter("txtCodVac"))));
                            obj.setDataMovimento(tF.parse(request.getParameter("txtDataMov") + " " + request.getParameter("txtHoraMov")));
                            obj.setTipoMovimento(request.getParameter("txtTipo"));
                            obj.setQtdeDose(Integer.parseInt(request.getParameter("txtQuant")));
                            daoJ = new DAOJPA();
                            obj.setCodigoLote(daoJ.loteByDescricao(bb, request.getParameter("txtLote")));
                            dao.create(obj);
%> 
                            <h1>Movimento de <%=obj.completarTipo()%> cadastrado com sucesso. </h1>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
                            break;
                            
                        case "Alterar":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findMovimentoVacina(cod);
                            if(obj == null)
                                throw new Exception("Esse movimento não existe.");
                            obj.setCodigoVacina(daoV.findVacina(Integer.parseInt(request.getParameter("txtCodVac"))));
                            obj.setDataMovimento(tF.parse(request.getParameter("txtDataMov") + " " + request.getParameter("txtHoraMov")));
                            obj.setTipoMovimento(request.getParameter("txtTipo"));
                            obj.setQtdeDose(Integer.parseInt(request.getParameter("txtQuant")));
                            daoJ = new DAOJPA();
                            obj.setCodigoLote(daoJ.loteByDescricao(bb, request.getParameter("txtLote")));
                            dao.edit(obj);
%>
<h1>Movimento de <%=obj.completarTipo()%> alterado com sucesso. </h1>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento<%
                            break;
                            
                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findMovimentoVacina(cod);
                            if(obj == null)
                                throw new Exception("Esse movimento não existe.");
                            dao.destroy(cod);
%>
                           <h1>Movimento de <%=obj.completarTipo()%> removido com sucesso.</h1>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
                            break;
                            
                        case "Consultar":
                            List<MovimentoVacina> lista = dao.findMovimentoVacinaEntities();
                            if(lista == null || lista.isEmpty())
                            {
                                throw new Exception("Lista nula ou vazia.");
                            }
                            else
                            {
                                String aux = "";
                                if(lista.size() > 1)
                                    aux = "s";
%>
                                <h1>Lista com <%=lista.size()%> movimento<%=aux%> encontrado<%=aux%></h1>
                                <form action="controleMovimento.jsp" method="post">
                                    <table border="1">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Código da vacina</th>
                                                <th>Data do movimento</th>
                                                <th>Hora do movimento</th>
                                                <th>Tipo</th>
                                                <th>Quantidade</th>
                                                <th>Lote</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<%
                                        for(int i = 0; i < lista.size(); i++)
                                        {
                                            obj = lista.get(i);
%>
                                            <tr>
                                                <td><input type="submit" name="bCarregar" value="<%=obj.getCodigo()%>"/></td>
                                                <td><%=obj.getCodigoVacina().getCodigo()%></td>
                                                <td><%=dF.format(obj.getDataMovimento())%></td>
                                                <td><%=hF.format(obj.getDataMovimento())%></td>
                                                <td><%=obj.completarTipo()%></td>
                                                <td><%=obj.getQtdeDose()%></td>
                                                <td><%=obj.getCodigoLote()%></td>
                                            </tr>
<%
                                        }
%>
                                        </tbody>
                                    </table>
                                </form>
                                Selecione o campo código de um movimento para carregar seus dados no formulário.<br/>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
                            }
                            break;

                        default:
                            throw new Exception("Erro inesperado ao ler evento do botão.");
                    }
                    Banco.conexao.close();
                }
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
%>
<h1>Erro: <%=ex.getMessage()%></h1>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
            }
%>
    </body>
</html>
