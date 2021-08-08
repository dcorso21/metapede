//////////////////////////////
// Topic
//////////////////////////////
interface topic {
    title:string, 
    description:string, 
    thumbnail: string, // url
    page_id: string
}

//////////////////////////////
// Resources
//////////////////////////////
interface time_period  {
    start_datetime: string,
    end_datetime: string,
    topic: topic,
    sub_topics : time_period[]
    events : event[]
}

interface event {
    id: string,
    datetime: string,
    topic: topic
}

interface image {
    id:string,
    title: string,
    description: string,
    url: string,
    topic: topic
}

interface sequence {
    id:string,
    resources: any[]
}

//////////////////////////////
// Parent
//////////////////////////////
interface resource {
    id:string,
    resource_type:string,
    connected_id:string
}