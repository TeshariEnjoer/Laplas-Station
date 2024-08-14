#define MAP_SERVER_STATUS_DISABLED 0
#define MAP_SERVER_STATUS_BOOTING 1
#define MAP_SERVER_STATUS_INGAME 2
#define DEFAULT_ABSTRACT_MAP_URL "http://127.0.0.1:5000/"

//Map server responses
#define AM_RESPONSE_SUCESS "sucess"
#define AM_RESPONSE_FAILED	"failed"

// Sync types
#define SYNC_TYPE_PHYSIC "physic" // Sync every physical value

//Map server requests
#define ABSTRACT_MAP_PING ""
#define ABSTRACT_MAP_SET_KEY "set_key"
#define ABSTRACT_MAP_RESET_KEY "reset_key"
#define ABSTRACT_MAP_INIT "init"
#define ABSTRACT_MAP_GET_RANDOM_POSITION "random_position"
#define ABSTRACT_MAP_SPAWN_OBJECT "create_obj"
#define ABSTRACT_MAP_REMOVE_OBJECT "remove_object"
#define ABSTRACT_MAP_MOVE_OBJECT "move_obj"
#define ABSTRACT_MAP_SYNC "sync"
