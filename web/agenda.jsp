<%--
AGENDA==========================================================================
Por meio desta página, o usuário poderá realizar o agendamento de sua vacinação.
--%>

<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.*"%>
<%@page import="controller.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gerenciamento de usuários</title>
        <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            //Mostra mensagem para o usuário durante sua consulta aos agendamentos
            function mensagem(p, d)
            {
                t = "";
                switch(p)
                {
                    case 1:
                       t = "A vacinação ainda não chegou. Vá ao posto de saúde no dia " + d + ", para vacinar-se.";
                       break;
                   case 2:
                       t = "O seu agendamento está atrasado, estava marcado para " + d + ". Vá no posto o quanto antes ou altere o seu agendamento.";
                       break;
                   default:
                       t = "Erro inesperado!";
                       break;
                }
                alert(t);
            }
        </script>
    </head>
    <body>
        <div class="home_content">
            <div class="title">Agenda</div> 
        <a href="index.jsp">Tela inicial</a>
<%
            request.setCharacterEncoding("UTF-8");
            
            //VARIÁVEIS
            Agenda obj;
            String b;
            AgendaJpaController dao;
            Banco bb;
            Usuario login = new Usuario();
            UsuarioJpaController daoU;
            boolean comum = false;
            
            try 
            {
                DAOJPA daoJ = new DAOJPA();
                bb = new Banco();
                dao = new AgendaJpaController(Banco.conexao);
                daoU = new UsuarioJpaController(Banco.conexao);
                //Formatadores de data necessários
                SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
                SimpleDateFormat tF = new SimpleDateFormat("dd/MM/yyyy HH:mm"); //Formatador geral
                SimpleDateFormat hF = new SimpleDateFormat("HH:mm"); //Formatador de horas
                
                //1. OBTER USUÁRIO LOGADO
                //1.1 Nenhum usuário logado
                if(session.getAttribute("login") == null)
                {
                    throw new Exception("Faça log-in antes!");
                }
                //1.2 Usuário comum (cidadão que quer vacinar-se) logado
                if(session.getAttribute("classe") == Usuario.class)
                {
                    login = (Usuario) session.getAttribute("login");
                    //1.2.1 Atualizando os dados de login
                    login = daoU.findUsuario(login.getCodigo());
                    session.setAttribute("login", login);
                    comum = true;
                }

                //2. FORMULÁRIOS PARA AGENDAMENTO (SEM OPERAÇÕES DO CRUD A FAZER)
                if(request.getParameter("b1") == null)
                {
                    //2.1 FORMULÁRIO PARA PREENCHER
                    if(request.getParameter("bCarregar") == null)
                    {
%>                      
                        <form action="agenda.jsp" method="post" onsubmit="return verificar(1)">
                            <div class="user-data"> <!-- O conteiner 'user-data' engloba todos os dados mais gerais do usarioa-->
                                <div class="input-box">
                                    <span class="data">Código</span>
                                    <input type="text" name="txtCod" id="idCod" readonly/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Data de vacinação</span>
                                    <input type="text" name="txtDataVacinacao" id="idDataVacinacao" placeholder="Digite a data de vacinação"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Hora de vacinação</span>
                                    <input type="text" name="txtHoraVacinacao" id="idHoraVacinacao" placeholder="Digite a hora da vacinação"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Número da dose</span>
                                    <input type="text" name="txtDoseNum" id="idDoseNum" placeholder="Digite o número da dose"/>
                                </div>
                            </div>
                            <div class="button">
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            </div>
                            <div class="btn_consult">
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                            </div>
                        </form>
<%
                    }
                    //2.2 FORMULÁRIO COM OS DADOS SELECIONADOS NA TABELA
                    else
                    {
                        obj = dao.findAgenda(Integer.parseInt(request.getParameter("bCarregar")));
%>
                        <form action="agenda.jsp" method="post" onsubmit="return verificar(1)">
                            <div class="user-data">
                                <div class="input-box">
                                    <span class="data">Código</span>
                                    <input type="text" name="txtCod" id="idCod" value="<%=obj.getCodigo()%>" readonly/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Data de vacinação</span>
                                    <input type="text" name="txtDataVacinacao" id="idDataVacinacao" placeholder="Digite a data de vacinação"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Hora de vacinação</span>
                                    <input type="text" name="txtHoraVacinacao" id="idHoraVacinacao" placeholder="Digite a hora da vacinação"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Número da dose</span>
                                    <input type="text" name="txtDoseNum" id="idDoseNum" placeholder="Digite o número da dose"/>
                                </div>
                            </div>
                            <div class="button"> <!-- Esse conteiner é o dos botões, engloba todos os botões que dispararão os eventos do form.-->
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            </div>
                            <div class="btn_consult">
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                            </div>
                        </form>
                        
                        <form action="agenda.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod" id="idCod" value="<%=obj.getCodigo()%>" readonly/> <br/>
                            Código do Usuário: <input type="text" name="txtCodU"  value="<%=obj.getCodigoUsuario().getCodigo()%>" readonly/> <br/>
                            Data de vacinação: <input type="text" name="txtDataVacinacao" id="idDataVacinacao" value="<%=dF.format(obj.getDataVacinacao())%>"/> <br/>
                            Hora de vacinação: <input type="text" name="txtHoraVacinacao" id="idHoraVacinacao" value="<%=hF.format(obj.getDataVacinacao())%>"/> <br/>
                            Número de dose: <input type="text" name="txtDoseNum" id="idDoseNum" value="<%=obj.getDoseNumero()%>"/><br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                            <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                        </form>
<%
                    }
                }
                //3. PROCESSAMENTO DO AGENDAMENTO (EXECUTÁ-LO DE FATO)
                else
                {
                    b = request.getParameter("b1");
                    int cod;
                    Timestamp hoje; //Pega data e hora do momento do agendamento
                    String dataHora;

                    switch(b)
                    {
                        //3.1 CRIAÇÃO DE UM NOVO AGENDAMENTO
                        case "Cadastrar":
                            if(login.getAgendaList().isEmpty()) {
                                obj = new Agenda();
                                hoje = new Timestamp(System.currentTimeMillis());
                                obj.setDataAgendamento(hoje);
                                if(session.getAttribute("classe") == UsuarioApl.class)
                                {
                                    daoU = new UsuarioJpaController(Banco.conexao);
                                    Usuario uu = daoU.findUsuario(Integer.parseInt(request.getParameter("txtCodU")));
                                    obj.setCodigoUsuario(uu);
                                }
                                obj.setCodigoUsuario(login);
                                dataHora = "" + request.getParameter("txtDataVacinacao") + " " + request.getParameter("txtHoraVacinacao");
                                obj.setDataVacinacao(tF.parse(dataHora));
                                obj.setDoseNumero(Integer.parseInt(request.getParameter("txtDoseNum")));
                                dao.create(obj);
%>
                                <h1>Agendamento concluído com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                            }
                            else {
                                List<Agenda> lista = login.getAgendaList();
                                for(int i = 0; i < lista.size(); i++)
                                {
                                    Agenda aux = lista.get(i);
                                    if(aux.getVacinacaoList().isEmpty())
                                    {
                                        hoje = new Timestamp(System.currentTimeMillis());
                                        String t = "Este usuário já possui um agendamento vigente. ";
                                        if(hoje.before(aux.getDataVacinacao()))
                                        {
                                            t += "Vá para o posto de vacinação no dia " + dF.format(aux.getDataVacinacao()) + ", às " + hF.format(aux.getDataVacinacao()) + ".";
                                        }
                                        else
                                        {
                                            t += "Seu agendamento passou do prazo, vacine-se o quanto antes ou altere o seu agendamento.";
                                        }
                                        throw new Exception(t);
                                    }
                                }
                                obj = new Agenda();
                                hoje = new Timestamp(System.currentTimeMillis());
                                obj.setDataAgendamento(hoje);
                                obj.setCodigoUsuario(login);
                                dataHora = "" + request.getParameter("txtDataVacinacao") + " " + request.getParameter("txtHoraVacinacao");
                                obj.setDataVacinacao(tF.parse(dataHora));
                                obj.setDoseNumero(Integer.parseInt(request.getParameter("txtDoseNum")));
                                dao.create(obj);
%>
                                <h1>Agendamento concluído com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%

                            }
                        break;

                        //3.2 ALTERAÇÃO DE AGENDAMENTO EXISTENTE
                        case "Alterar":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findAgenda(cod);
                            if(obj == null)
                                throw new Exception("Esse agendamento não existe.");

                            hoje = new Timestamp(System.currentTimeMillis());
                            obj.setDataAgendamento(hoje);
                            dataHora = "" + request.getParameter("txtDataVacinacao") + " " + request.getParameter("txtHoraVacinacao");
                            obj.setDataVacinacao(tF.parse(dataHora));
                            obj.setDoseNumero(Integer.parseInt(request.getParameter("txtDoseNum")));
                            dao.edit(obj);
%>
                            <h1>Agendamento alterado com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                        break;

                        //3.3 EXCLUSÃO DE AGENDAMENTO
                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findAgenda(cod);
                            if(obj == null)
                                throw new Exception("Esse agendamento não existe.");

                            dao.destroy(cod);
                            login = daoU.findUsuario(login.getCodigo());
                            session.setAttribute("login", login);
%>
                            <h1>Agendamento removido com sucesso.</h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                        break;
                        
                        //3.4 CONSULTA DE AGENDAMENTOS
                        case "Consultar":
                            List<Agenda> lista;
                            if(comum)
                                lista = login.getAgendaList();
                            else
                                lista = dao.findAgendaEntities();
                            if(lista == null || lista.isEmpty())
                            {
                                throw new Exception("Lista nula ou vazia.");
                            }
                            else
                            {
%>
                                <h1>Agendamento</h1>
<%
                                //Este formulário dentro do if só é acessível a gestores e enfermeiros
                                if(!comum)
                                {
%>
                                    <form action="agenda.jsp" method="post">
                                        Filtrar dados pelo CPF:<br/>
                                        <input type="text" name="txtCPF"/><input type="submit" name="b1" value="Pesquisar"/>
                                    </form>
<%
                                }
                                //3.4.1 CONSTRUÇÃO DA TABELA
%>
                                <table border="1">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Data de modificação</th>
                                            <th>Hora de modificação</th>
                                            <th>Código de usuário</th>
                                            <th>Data marcada</th>
                                            <th>Hora marcada</th>
                                            <th>Data da aplicação</th>
                                            <th>Hora da aplicação</th>
                                            <th>Número da dose</th>
                                            <th>Comprovante</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<%
                                        for(int i = 0; i < lista.size(); i++)
                                        {
                                            obj = lista.get(i);
%>
                                            <tr>
                                                <td><a href="agenda.jsp?bCarregar=<%=obj.getCodigo()%>"><%=obj.getCodigo()%></a></td>
                                                <td><%=dF.format(obj.getDataAgendamento())%></td>
                                                <td><%=hF.format(obj.getDataAgendamento())%></td>
                                                <td><%=obj.getCodigoUsuario().getCodigo()%></td>
                                                <td><%=dF.format(obj.getDataVacinacao())%></td>
                                                <td><%=hF.format(obj.getDataVacinacao())%></td>
<%
                                                //3.4.1.1 CONFERINDO SE A PESSOA JÁ SE VACINOU E ACRESCENTANDO A DATA À TABELA
                                                
                                                boolean vacinou = false;
                                                Vacinacao vac = new Vacinacao();
                                                
                                                if(!obj.getVacinacaoList().isEmpty())
                                                {
                                                    vac = obj.getVacinacaoList().get(0);
                                                    vacinou = true;
%>
                                                    <td><%=dF.format(vac.getDataAplicacao())%></td>
                                                    <td><%=hF.format(vac.getDataAplicacao())%></td>
<%
                                                }
                                                else {
%>
                                                    <td>--/--/----</td>
                                                    <td>--:--</td>
<%
                                                }
%>
                                                <td><%=obj.getDoseNumero()%></td>
                                                <td>
<%                                                  
                                                    //Se já vacinou, tem a possibilidade de imprimir seu comprovante.
                                                    if(vacinou) { 
                                                        int codVac = vac.getCodigo();
%>
                                                        <a href="imprimirComprovante.jsp?vacinacao=<%=codVac%>">Acessar</a> 
<%
                                                    }
                                                    //Se ainda não vacinou, receberá uma mensagem a depender de se já deveria ou não ter tomado a vacina. 
                                                    else {
                                                        int param = 2; //1 para agendamento futuro e 2 para atrasado
                                                        hoje = new Timestamp(System.currentTimeMillis());

                                                        if(hoje.before(obj.getDataVacinacao()))
                                                            param = 1;
%>                                                        
                                                        <button onclick="mensagem(<%=param%>, '<%=dF.format(obj.getDataVacinacao()) + ", às " + hF.format(obj.getDataVacinacao())%>')">Saiba mais</button>
<%
                                                    }
%>
                                                </td>
                                            </tr>
<%
                                        }
%>
                                        </tbody>
                                    </table>
                               
                                Selecione o campo código de um agendamento para carregar seus dados no formulário.<br/>
                                Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                            }
                            break;
                        
                        //3.5 PESQUISA DE AGENDAMENTOS POR CPF (SÓ DISPONÍVEL A GESTORES E ENFERMEIROS)
                        case "Pesquisar":
                            List<Agenda> lR; //lista resultante da pesquisa
                            Usuario uR = new Usuario(); //usuário resultante da pesquisa
                            uR = (Usuario)daoJ.searchCPF(bb, request.getParameter("txtCPF"), uR.getClass());
                            lR = uR.getAgendaList();

                            if(lR == null || lR.isEmpty()) {
                                throw new Exception("Lista nula ou vazia.");
                            }
                            //3.5.1 MOSTRANDO A LISTA DE AGENDAMENTOS RECEBIDA PELA CONSULTA
                            else {
%>
                                <h1>Agendamento</h1>
                               <%
                                   if(!comum)
                                    {
                                   %><form action="agenda.jsp" method="post">
                                       Filtrar dados pelo CPF:<br/>
                                       <input type="text" name="txtCPF"/><input type="submit" name="b1" value="Pesquisar"/>
                                    </form><%
                                        }
                               %>
                                <table border="1">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Data de modificação</th>
                                            <th>Hora de modificação</th>
                                            <th>Código de usuário</th>
                                            <th>Data marcada</th>
                                            <th>Hora marcada</th>
                                            <th>Data da aplicação</th>
                                            <th>Hora da aplicação</th>
                                            <th>Número da dose</th>
                                            <th>Comprovante</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<%
                                        for(int i = 0; i < lR.size(); i++)
                                        {
                                            obj = lR.get(i);
%>
                                            <tr>
                                                <td><a href="agenda.jsp?bCarregar=<%=obj.getCodigo()%>"><%=obj.getCodigo()%></a></td>
                                                <td><%=dF.format(obj.getDataAgendamento())%></td>
                                                <td><%=hF.format(obj.getDataAgendamento())%></td>
                                                <td><%=obj.getCodigoUsuario().getCodigo()%></td>
                                                <td><%=dF.format(obj.getDataVacinacao())%></td>
                                                <td><%=hF.format(obj.getDataVacinacao())%></td>
<%
                                                    //3.5.1.1 CONFERINDO SE A PESSOA JÁ SE VACINOU E ACRESCENTANDO A DATA À TABELA
                                                    boolean vacinou = false;
                                                    Vacinacao vac = new Vacinacao();
                                                    
                                                    if(!obj.getVacinacaoList().isEmpty())
                                                    {
                                                        vac = obj.getVacinacaoList().get(0);
                                                        vacinou = true;
                                                        %><td><%=dF.format(vac.getDataAplicacao())%></td>
                                                        <td><%=hF.format(vac.getDataAplicacao())%></td><%
                                                    }
                                                    else
                                                    {
                                                        %><td>--/--/----</td>
                                                        <td>--:--</td><%
                                                    }
                                                %>
                                                <td><%=obj.getDoseNumero()%></td>
                                                <td>
                                                <%
                                                    //Se já vacinou, tem a possibilidade de imprimir seu comprovante.
                                                    if(vacinou)
                                                    { 
                                                        int codVac = vac.getCodigo();
                                                        %><a href="imprimirComprovante.jsp?vacinacao=<%=codVac%>">Acessar</a> <%
                                                    }
                                                    //Se ainda não vacinou, receberá uma mensagem a depender de se já deveria ou não ter tomado a vacina. 
                                                    else
                                                    {
                                                        int param = 2; //1 para agendamento futuro e 2 para atrasado
                                                        hoje = new Timestamp(System.currentTimeMillis());
                                                        if(hoje.before(obj.getDataVacinacao()))
                                                            param = 1;
%>                                                        
                                                        <button onclick="mensagem(<%=param%>, '<%=dF.format(obj.getDataVacinacao()) + ", às " + hF.format(obj.getDataVacinacao())%>')">Saiba mais</button>
<%
                                                    }
%>
                                                </td>
                                            </tr>
<%
                                        }
%>
                                        </tbody>
                                    </table>
                               
                                Selecione o campo código de um agendamento para carregar seus dados no formulário.<br/>
                                Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                            }
                            break;
                        
                        //3.6 CASO ALGUMA AÇÃO INVÁLIDA SEJA REQUERIDA PELO USUÁRIO
                        default:
                            throw new Exception("Erro inesperado ao ler evento do botão.");
                    }
                    Banco.conexao.close();
                }
            }
            //Captura e tratamento de possíveis exceções
            catch(Exception ex) {
                Banco.conexao.close();
%>
                <h1>Erro: <%=ex.getMessage()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
            }
%>
        </div>
</body>