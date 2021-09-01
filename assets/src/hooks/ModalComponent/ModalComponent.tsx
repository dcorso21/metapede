import React from "react";

interface Props {
    msg: string;
}

export const ModalComponent: React.FC<Props> = ({msg}) => {
    return <div>{msg}</div>;
};
