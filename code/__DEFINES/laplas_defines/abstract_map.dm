#define MAP_SERVER_STATUS_DISABLED 0
#define MAP_SERVER_STATUS_BOOTING 1
#define MAP_SERVER_STATUS_INGAME 2
#define DEFAULT_ABSTRACT_MAP_URL "http://localhost:5000/"


//
#define ABSTRACT_MAP_REQUEST(function, data) rustg_http_request_async(RUSTG_HTTP_METHOD_GET, DEFAULT_ABSTRACT_MAP_URL + function, data, null, null)

//Http server respons
#define AM_RESPONSE_SUCESS "sucess"
#define AM_RESPONSE_FAILED	"failed"


#define ABSTRACT_MAP_SET_KEY "set_key"
#define ABSTRACT_MAP_RESET_KEY "reset_key"
#define ABSTRACT_MAP_INIT "init"
