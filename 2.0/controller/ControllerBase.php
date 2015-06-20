<?php

abstract class ControllerBase {
    /**
     * @var object
     * responsável por armazenar a instância do Usuário atual logado
     */
    protected $CurrentUser;
    protected $currentAction;   

    protected static $view = Config::DEFAULT_MODULE;


    /**
     * Indices de sessão
     */
    const IDX_LAST_ARGS   = 'idx_00';
    const IDX_LOGGED      = 'idx_01';
    const IDX_LAST_LOGGED = 'idx_02';
    const IDX_LOGIN_MSG   = 'idx_03';


    /**
     * Construtor
     */
    public function __construct() {
        if (!User::hasLogged()) $this->handleLoginRequest();
        else {
            $this->User = User::getLogged();

            if (!is_object($this->User)) User::logout(Alert::MSG_LOGIN_UNKNOWN_ERROR);
            else                         $this->managePost();
        }
    }

    private function managePost() {
        if ($_POST and isset($_POST['action'])) $_SESSION[self::IDX_LAST_ARGS] = serialize($_POST);
        unset($_POST);

        $arguments = self::getLastArgs();
        $hasAction = isset($arguments['action']) && ($arguments['action'] != '');

        if ($hasAction) $this->action($arguments);
        else            $this->goHome();
    }	

    protected static function getLastArgs() {
        return isset($_SESSION[self::IDX_LAST_ARGS]) ? unserialize($_SESSION[self::IDX_LAST_ARGS]) : array();
    }

    protected static function clearLastArgs() {
        unset($_SESSION[self::IDX_LAST_ARGS]);
    }

    private function handleLoginRequest() {

        if (!$_POST && !isset($_POST['action'])) {
            self::loadLogin();
        }

        else {
            switch ($_POST['action']) {              
                case 'login':                                                                                       
                    $this->login($_POST);                                                         
                break;
                
                default:                                                                                            
                    $_SESSION[self::IDX_LOGIN_MSG] = Alert::MSG_SYSTEM_LOGIN_ERROR;
                   
                    unset($_POST);
                    self::loadLogin();                                                          
                break;
            }

            unset($_POST);
        }
    }

    protected function login($args) {

        if (!isset($args['username']) || !isset($args['password'])) {
            $_SESSION[self::IDX_LOGIN_MSG] = Alert::MSG_USER_FIELDS;
        }
        else {
            $status = User::login($args['username'], $args['password']);

            switch ($status) {
                case User::USR_LOGGED:                     
                break;
                
                case User::USR_INACTIVE:
                    $_SESSION[self::IDX_LOGIN_MSG] = Alert::MSG_LOGIN_INACTIVE;
                break;
                        
                case User::USR_UNKNOW:
                case User::USR_PW_INVALID:
                    $_SESSION[self::IDX_LOGIN_MSG] = Alert::MSG_LOGIN_WRONG_PASS;
                break;

                case User::USR_TIMEOUT:
                    $_SESSION[self::IDX_LOGIN_MSG] = Alert::MSG_LOGIN_TIMEOUT;
                break;
                
                default:
                    $_SESSION[self::IDX_LOGIN_MSG] = Alert::MSG_SYSTEM_CONNECTION_OUT;
                break;
            }
        }
     
        header('Location: ../' . static::$view);
    }

    final protected function refreshLoggedUser() {
        User::setLogged($this->CurrentUser);
    }

    protected function returnPage($arguments) {
        return false;   
    }

    /**
     * @author Leandro Medeiros
     *
     * Método responsável por fazer a chamada das funções.
     * Pelo fato do método ser genérico, existe 3 possíveis tipos de retorno, são eles:
     * Booleano, objeto PageContent, string JSON.
     * O retorno booleano ocorre quando não é preciso realizar mudança de estado da view, apenas atualizá-la
     * O retorno objeto PageContent ocorre quando, após a execução da função, haverá uma chamada de uma view.
     * O retorno JSON ocorre quando a requisição é feita em ajax, e após sua execução, precisamos manipular a view.
     *
     * @var string $postAction 
     * recebe o valor armazenanado na variável de sessão 'POST', contendo o método solicitado, sendo uma requisição AJAX ou não.
     *
     * @var string $page recebe o retorno da chamada de função
     */
    final protected function action($arguments) {
        
        $postAction = isset($arguments['action']) ? $arguments['action'] : null;

        if (!method_exists($this, $postAction)) {
            if ($postAction) new Alert(sprintf(Alert::MSG_SYSTEM_METHOD_FAIL, get_class($this), $postAction), Alert::ERROR);
            $this->goHome();
        }

        else {
            $page = $this->$postAction($arguments);

            try {
                if (is_string($page)) {
                    ControllerBase::clearLastArgs();
                    echo $page;
                }
                
                else if (is_bool($page)) {
                    ControllerBase::clearLastArgs();
                    $this->goHome($page);
                }
                
                else if (get_class($page) == 'PageContent') {
                    $page->CurrentUser = $this->CurrentUser;
                    self::loadPage($page);
                }

                else if (get_class($page) == 'FileDownload') {
                    ControllerBase::clearLastArgs();
                    $page->download();
                }
            }
            catch (Exception $e) {
                $this->goHome(true);
            }
        }
    }    

    abstract protected function goHome();

    protected function logout($message) {
        User::logout($message); 
    } 

    protected static function loadPage(PageContent $PageContent, $headerContent = true) {
        require("../view/header.php");
        if ($headerContent)
            require("../view/header-content.php");
        require("../{$PageContent->module}/view.php");
        require("../view/footer.php");
    }

    private static function loadLogin($message = null) {
        self::loadPage(new PageContent("login", "Login", $message), false);
    }    
}