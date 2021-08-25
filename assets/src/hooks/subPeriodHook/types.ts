export interface TimePeriod {
    _id: string;
    inserted_at: string;
    updated_at: string;
    start_datetime: string;
    end_datetime: string;
    expand: boolean;
    topic: Topic;
    sub_time_periods: TimePeriod[] | number;
    depth: number;
    has_sub_periods: boolean,

    // added later
    start: number;
    end: number;
    ml: string;
    width: string;
}

export interface Topic {
    inserted_at: string;
    updated_at: string;
    title: string;
    description: string;
    thumbnail: string;
    page_id: string;
}